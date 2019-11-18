#!/bin/env python3

import re
import time
import operator
from fuzzywuzzy import process, fuzz
from collections import OrderedDict

from gi.repository import GLib
import dbus
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop

DBusGMainLoop(set_as_default=True)

DBUS_BUS_NAME = "ro.niflo.purple_krunner"
DBUS_PATH = "/purple_search"
DBUS_IFACE = "org.kde.krunner1"

TOKEN_RE = re.compile(r'\w+')


class PurpleRunner(dbus.service.Object):
    def __init__(self):
        self._users = {}
        self._words = {}
        self._word_keys = []

        # connect to Pidgin's DBus interface
        self._session = dbus.SessionBus()
        obj = self._session.get_object("im.pidgin.purple.PurpleService",
                                       "/im/pidgin/purple/PurpleObject")
        self._purple = dbus.Interface(obj, "im.pidgin.purple.PurpleInterface")

        self.refresh_buddies()

        dbus.service.Object.__init__(
            self, dbus.service.BusName(
                DBUS_BUS_NAME, dbus.SessionBus()), DBUS_PATH)

        GLib.timeout_add(300000, self.refresh_buddies)

    @dbus.service.method(DBUS_IFACE, out_signature='a(sss)')
    def Actions(self, msg):
        return []

    @dbus.service.method(DBUS_IFACE, in_signature='s',
                         out_signature='a(sssida{sv})')
    def Match(self, query):
        if len(query) < 3:
            return []

        # we need to match each word (token) individually and "combine" the sets
        tokens = self._tokenize_string(query)
        match_dict = {}
        for tok in tokens:
            match_list = process.extract(
                tok, self._word_keys, scorer=fuzz.partial_ratio, limit=20)
            for key, relevance in match_list:
                m = match_dict.get(key, (0, 1))
                # we just average them later
                match_dict[key] = (m[0]+1, m[1] + relevance)
        items = [(key, (m[1] / m[0])) for key, m in match_dict.items()]
        items.sort(key=lambda km: km[1])

        matches = []
        for key, relevance in items:
            uid = self._words[key]
            user = self._users[uid]
            # actionId, actionName, iconName, Type, relevance (0-1), properties
            username = user["alias"]
            if not username:
                username = user["name"]
            username += " (" + user["protocol"] + ")"
            matches.append((uid, username, "user-available",
                            100, relevance, {}))
        return matches

    @dbus.service.method(DBUS_IFACE, in_signature='ss',)
    def Run(self, matchId, actionId):
        if matchId not in self._users:
            return
        user = self._users[matchId]
        self.open_conversation(user)
        return

    def refresh_buddies(self):
        # get list of accounts
        accounts = self._purple.PurpleAccountsGetAllActive()

        self._words = {}
        self._users = {}

        for accountId in accounts:
            connectionId = self._purple.PurpleAccountGetConnection(accountId)
            accountName = self._purple.PurpleAccountGetUsername(accountId)
            protocolName = self._purple.PurpleAccountGetProtocolName(accountId)
            connectionName = self._purple.PurpleConnectionGetDisplayName(connectionId)
            # protocol = self._purple.PurpleConnectionGetDisplayName(connectionId)

            if not connectionId:
                continue

            # get list of users for an account
            userIds = self._purple.PurpleFindBuddies(accountId, "")
            for userId in userIds:
                uid = str(accountId) + "_" + str(userId)
                user = {
                    "id": userId,
                    "type": "user",
                    "name": self._purple.PurpleBuddyGetName(userId),
                    "alias": self._purple.PurpleBuddyGetAlias(userId),
                    "accountId": accountId,
                    "account": accountName,
                    "protocol": protocolName,
                    "connectionName": connectionName
                }
                user["score"] = self._purple.PurpleLogGetActivityScore(
                    1, user["name"], accountId)
                self._users[uid] = user

                tokens = set()
                tokens.update(self._tokenize_string(user["name"]))
                tokens.update(self._tokenize_string(user["alias"]))
                tokens.update(self._tokenize_string(user["protocol"]))
                token = " ".join(tokens)
                self._words[token] = uid

        # also get the list of joined chats
        chats = self._purple.PurpleGetChats(accountId, "")
        for chat in chats:
            self._purple.PurpleConversationGetTitle(chat),
            # self._purple.PurpleConvChatGetTopic(self._purple.PurpleConversationGetChatData(chat)),
            accountId = self._purple.PurpleConversationGetAccount(chat)
            connectionId = self._purple.PurpleAccountGetConnection(accountId)
            accountName = self._purple.PurpleAccountGetUsername(accountId)
            protocolName = self._purple.PurpleAccountGetProtocolName(accountId)
            connectionName = self._purple.PurpleConnectionGetDisplayName(connectionId)
            user = {
                "id": chat,
                "type": "chat",
                "name": self._purple.PurpleConversationGetName(chat),
                "alias": self._purple.PurpleConversationGetTitle(chat),
                "accountId": accountId,
                "account": accountName,
                "protocol": protocolName,
                "connectionName": connectionName
            }
            print(user)
            uid = "chat_" + str(accountId) + "_" + str(chat)
            self._users[uid] = user

            tokens = set()
            tokens.update(self._tokenize_string(user["name"]))
            tokens.update(self._tokenize_string(user["alias"]))
            tokens.update(self._tokenize_string(user["protocol"]))
            token = " ".join(tokens)
            self._words[token] = uid

        self._word_keys = self._words.keys()

    def open_conversation(self, user):
        """ Starts / focuses a specific conversation """
        conv_type = 2 if user["type"] == "chat" else 1
        conversationId = self._purple.PurpleConversationNew(conv_type, user["accountId"], user["name"])
        self._purple.PurpleConversationPresent(conversationId)

        # Next we make a new IM out of the conversation (yep...)
        if (conv_type == 2):
            imId = self._purple.PurpleConvIm(conversationId)

        # Send a notification to highlight the conversation
        #self._purple.PurpleConvImWrite(
        #    imId, "System", "Here's your conversation, as requested, sir!",
        #    0x0004 | 0x8000 | 0x2000, time.time())

    @staticmethod
    def _tokenize_string(s):
        tokens = set(re.findall(r'\w{3,}', s))
        return tokens


runner = PurpleRunner()
loop = GLib.MainLoop()
loop.run()

