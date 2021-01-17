Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D413C2F93C2
	for <lists+linux-fscrypt@lfdr.de>; Sun, 17 Jan 2021 16:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbhAQP5h (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 17 Jan 2021 10:57:37 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38115 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728350AbhAQP5e (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 17 Jan 2021 10:57:34 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 7637A5C00AA
        for <linux-fscrypt@vger.kernel.org>; Sun, 17 Jan 2021 10:56:27 -0500 (EST)
Received: from imap10 ([10.202.2.60])
  by compute1.internal (MEProxy); Sun, 17 Jan 2021 10:56:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=e+uxnTgb+hzVqdScMu8OFAWZfr4A5
        bOG471Y2Tvsx0M=; b=KpwU2Z58L3CkMPHRtAPKqZIe3+19IAToBFcTX4aH5HRz9
        rF/YCWxpNwV2czAf0dEKw5kEviE7n+mIcim/Bw8duI4aRGipfWx5pM3rnP6NR4Mr
        Za9V44K85LWqaY239Rw8WKJJAGgmX7c7e7CsYPFroxdtfCw6YMmDj+2SK9YiagJL
        p2cyLWmZf0LO/LtV0uMfe3lhphSGVAlXZ5qx6CRlcfWgIOLFDNTmZi0XgQrMREA6
        wMtfyCE4Ko2+LUhnA1+9YV88HzV7tHclrls2XJBHfXkdePaXHWXJtBn8DKw7RXPM
        gksWjtfhugLDCgqxHQaMPihVkKsKJj2GyJnT0whrg==
X-ME-Sender: <xms:K14EYJ8zF26b0v79jrWcOj9MvtFf-e53l2HQYx2tQoLFeWt21RnCUw>
    <xme:K14EYNvwy3iUIH2NzgQmL53kGSnJiOrjbl1Y1m6EFuicCFNHJOOTihZJzJEWRQMxB
    sMJdnH5SWoOWEf5>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdekhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepofgfggfkfffhvffutgesthdtredtre
    ertdenucfhrhhomhepfdevohhlihhnucghrghlthgvrhhsfdcuoeifrghlthgvrhhssehv
    vghrsghumhdrohhrgheqnecuggftrfgrthhtvghrnhepfedugefgvdetueevtdejgeehgf
    eiveefheffkeejhfevueekleettdegudegieefnecuffhomhgrihhnpehkvghrnhgvlhdr
    ohhrghdpghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepfigrlhhtvghrshesvhgvrhgsuhhmrdhorhhg
X-ME-Proxy: <xmx:K14EYHCnfpSUTf0i4dCrFexsQv5k0Usigf7yAk9PdaA5HRwQZ4XPYA>
    <xmx:K14EYNdWf8SKB6aCQkCGOZs5Yhk6E-WXn8zO9_KBgufZLxAqv9eCvA>
    <xmx:K14EYOPntM6PfNO9zi4V7FHSEzRmy__oKItzJoLtJPg_UZI8kkbhSA>
    <xmx:K14EYAs4zzZlYmBJ8OefkQyrAUC_nro6smWPlET52Lkqi_KO9uybTA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 21DAC20066; Sun, 17 Jan 2021 10:56:27 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-45-g4839256-fm-20210104.001-g48392560
Mime-Version: 1.0
Message-Id: <2369a655-d7e8-467c-8003-860d35ef1026@www.fastmail.com>
Date:   Sun, 17 Jan 2021 10:56:06 -0500
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


