Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827492F92D5
	for <lists+linux-fscrypt@lfdr.de>; Sun, 17 Jan 2021 15:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbhAQOWB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 17 Jan 2021 09:22:01 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47653 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729101AbhAQOV7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 17 Jan 2021 09:21:59 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 378D75C00B2
        for <linux-fscrypt@vger.kernel.org>; Sun, 17 Jan 2021 09:20:53 -0500 (EST)
Received: from imap10 ([10.202.2.60])
  by compute1.internal (MEProxy); Sun, 17 Jan 2021 09:20:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=e+uxnTgb+hzVqdScMu8OFAWZfr4A5
        bOG471Y2Tvsx0M=; b=ZqE42LiyHPvC1eImsA5/amBbqw2KDnyaKsHsQ46znB+HT
        n5cjCv8Sh16aR2V+FD8LocmyWAlxhYvHVWAuksor87uHE7ux8jauicqbAfUyX9dk
        5YJuNzqjXmQ1r6vnAwSchBXRndWZ21u/bRM6+hOfOCJpsjVsJCmeqyECabWVY50A
        Rb+IeQAws3q1tBnYofa0jh6RQnFOmTFD9hVncD2xepMM6IwrwpCvDd58EsImXLlm
        6xxdyOrrqfpiEKt42SYku/jcXm3XnquZvKdFCNKLOKb6hDk0yx5H0ArGc/WLNzBe
        fmexI5pEWA7+bjG0YzH2KFwJvQjaIGfoqgMdT3LKw==
X-ME-Sender: <xms:xUcEYORxnFJJEIZ1I2p_Ea1P_hrDk8qok1Umv2dGGvXfcf9Pl_1idA>
    <xme:xUcEYDxyFbkS6lGHZ46m_xYa4sx3gCrMfwQdguDcPcKPq2lZTml1vgsZGrYP4LHjh
    fwbEfDKrDyGQIS_>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepofgfggfkfffhvffutgesthdtredtre
    ertdenucfhrhhomhepfdevohhlihhnucghrghlthgvrhhsfdcuoeifrghlthgvrhhssehv
    vghrsghumhdrohhrgheqnecuggftrfgrthhtvghrnhepfedugefgvdetueevtdejgeehgf
    eiveefheffkeejhfevueekleettdegudegieefnecuffhomhgrihhnpehkvghrnhgvlhdr
    ohhrghdpghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepfigrlhhtvghrshesvhgvrhgsuhhmrdhorhhg
X-ME-Proxy: <xmx:xUcEYL3jc2HUgKKHkw3RxBYvIw_NhMKsdKuNyLLIQrGH1y-TwQxY8Q>
    <xmx:xUcEYKAxE7rLQ6OmiH-8opzB2S8Nn8srnUqCtcZ4DE5WGamF142YuQ>
    <xmx:xUcEYHilhTRglHMjhUrRfwwxs-2SQK--7V0LUxQmVjj77p54ag3QLQ>
    <xmx:xUcEYGRWXW2H4oRxOqO3T7bf59v4lCRefsQ7fBYx4agv2vtqbFq9NQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 0500920066; Sun, 17 Jan 2021 09:20:53 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-45-g4839256-fm-20210104.001-g48392560
Mime-Version: 1.0
Message-Id: <cc99418f-4171-4113-9689-afcf46695d95@www.fastmail.com>
Date:   Sun, 17 Jan 2021 09:20:32 -0500
From:   "Colin Walters" <walters@verbum.org>
To:     linux-fscrypt@vger.kernel.org
Subject: new libfsverity release?
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

There's been a good amount of changes since the last libfsverity release.  I'm primarily interested in
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/commit/?id=f76d01b8ce8ce13538bac89afa8acfea9e2bdd57

I have some work in progress to update the ostree fsverity support to use it:
https://github.com/ostreedev/ostree/pull/2269

Anything blocking a release?

While I'm here, some feedback on the new library APIs:

- ostree is multi-threaded, and a process global error callback is problematic for that.  I think a GLib-style "GError" type which is really just a pair of error code and string is better.
- Supporting passing the keys via file descriptor or byte array would be nice; or perhaps even better than that we should just expose the openssl types and allow passing pre-parsed key+certificate?


