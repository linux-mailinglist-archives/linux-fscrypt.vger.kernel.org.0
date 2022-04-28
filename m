Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179B7513E74
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 Apr 2022 00:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352837AbiD1WWp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 28 Apr 2022 18:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237230AbiD1WWo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 28 Apr 2022 18:22:44 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6203BF32C
        for <linux-fscrypt@vger.kernel.org>; Thu, 28 Apr 2022 15:19:27 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 19A3B3200958;
        Thu, 28 Apr 2022 18:19:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 28 Apr 2022 18:19:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1651184366; x=1651270766; bh=Y+c8HV7Fg2rf1/jEIPEiKBQw4
        Db6f/C6BdEnExK+zZ8=; b=YUiBLmHaMnZ3AZhMJTYgc64iM8gJpvtXndfuhqDPT
        pRFZmPgQZxulMX1xb+jMFzdyRUcKBlzGtDm8mL9eGq1p9Zs0hnk1rhqaCYAXpe9b
        AzUZmGSLkbB9wnjMCfqXKwcpbNMThGnO/1Fc0439bkcWXCuoWCmSyHGCX2szOBvb
        N1nihWteVnJlQsDFqC8TE2zJrXPtyl2/fk1RI7/5zgH4MNzP6CD8h/zSNid/mc18
        uEJ6BhX9FL55LH7RvwWs/5Wlj9wdJX1Kl120qdTqORh5Lg6R+FFkxuR2HZfKke12
        Lfk7FfcnTA4PL88Fwyc/bRX1kT9AA3FK7tLItbpWOHz2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; t=1651184366; x=1651270766; bh=Y
        +c8HV7Fg2rf1/jEIPEiKBQw4Db6f/C6BdEnExK+zZ8=; b=jywWfIeZwiI/q1Nta
        WUE3D89BmJiaze458xS3y8sXbjd7kRBOvyX1rbNamADwLSOZj7uT6RzcEw2WNInj
        RClsXEKDcKrLNEHxvqLN35RT20e6SohbuC1r9DlTAbDIDiehCOoZIWpdsYmtPkLL
        5hWZ6faijf/5G3NAw4bZ2ON7uFiHUEBWrWIWTcmhmhLgi9KmvNliyFDRifCR8sh+
        Ltcks62QcFIQ2k7mFHDDklzDCsiaPdgQp91XEuy+0ZgxHLkaD3C3MiKI7ofievgc
        WLnNSy8vJb3tP7G9JIOQaVp2znYR3m6UIZrCPtw+OEsZN7R7t7f5Hq+ldPsRk9K3
        q0Yeg==
X-ME-Sender: <xms:7hJrYkmWGyBqgIMFkAiqZYvD83UmpR5RfURt3CjERRfMA-VikkM37g>
    <xme:7hJrYj2vBpbNwtLW6n06r3HcXtmGMr8k_G_BtbcqtZWatTefSnxb03h7jFrWTqGUc
    Tk54ggLyp54vz8EEJw>
X-ME-Received: <xmr:7hJrYirD5Uslqxnu5kkQiQCZ5lIB9iHtBCPqr8fBe416z2sjyrOtD_KN4O4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekuddute
    efkefffeethfdvjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:7hJrYglBx1nIW0oDWbkBtzRVRxRnSikZ02YZEtBYFfKM7dHSVoo50Q>
    <xmx:7hJrYi2L1DydQgzvF2HuPqjJLBt9UALlYP5EkocVfBtQsWgKzes31g>
    <xmx:7hJrYntM7K_ADkRMYLFC4pOCqHSXexcDGWEItuPfXsWdtQiUfAogbQ>
    <xmx:7hJrYn9bNPB7_cmvfKCMNnsLcvYKrA1bT0gGTWfKM1YImlWIVOWR9g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 28 Apr 2022 18:19:25 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 0/2] fsverity: killswitch sysctl
Date:   Thu, 28 Apr 2022 15:19:18 -0700
Message-Id: <cover.1651184207.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

These patches add a new fs-verity sysctl that allows the administrator
to set verity in a log-only audit mode or disable it entirely.

Boris Burkov (2):
  fsverity: factor out sysctl from signature.c
  fsverity: add mode sysctl

 fs/verity/Makefile           |   2 +
 fs/verity/enable.c           |   3 +
 fs/verity/fsverity_private.h |  24 ++++++++
 fs/verity/init.c             |   7 ++-
 fs/verity/measure.c          |   3 +
 fs/verity/open.c             |  14 ++++-
 fs/verity/read_metadata.c    |   3 +
 fs/verity/signature.c        |  68 +++++-----------------
 fs/verity/sysctl.c           | 110 +++++++++++++++++++++++++++++++++++
 fs/verity/verify.c           |  34 ++++++++++-
 include/linux/fsverity.h     |   4 +-
 11 files changed, 210 insertions(+), 62 deletions(-)
 create mode 100644 fs/verity/sysctl.c

-- 
2.30.2

