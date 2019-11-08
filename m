Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 399F1F572B
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Nov 2019 21:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389507AbfKHTS5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 8 Nov 2019 14:18:57 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:51519 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387560AbfKHTSy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 8 Nov 2019 14:18:54 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 997BB187
        for <linux-fscrypt@vger.kernel.org>; Fri,  8 Nov 2019 14:18:53 -0500 (EST)
Received: from imap37 ([10.202.2.87])
  by compute3.internal (MEProxy); Fri, 08 Nov 2019 14:18:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=mx2RdF/2L93Izis0x1VdtxMgJourF
        7t7Gts98N1YvKE=; b=Mx+u0nsl07bbVZb0ZhX3mdxdlMhJFpEm2WpXPXQSbL8qK
        K/DCfjXIjNHCfq7WceD7RYyrNRWkItsCVGT93J/EZ9CZZRhZ1QKdqzYi1tieBR2H
        BRIWF0g5JRssumjqx/0I8VIaH3/diNAPlpYGuf3TNqcBVoFG/h+AfmhCXu3Oii5p
        YENFDgjtz+clQK5aQIfTgcJElaWCVccJ+9Oty2BNoHisrCxHTpyuvE4AJOJ86a/+
        PgdM7fs0DQblxhEf+a8KGPxA3xbEughiIcJDBbh+RBhnMbrTOzXvR0Cl23RPo0WQ
        Hu5B+sgVt96+3jZII0hY93ratLU5mlHPezueWNqgg==
X-ME-Sender: <xms:nb_FXR38IvfmquXinfDMAyJ5T41-1EVSsf4e9C9SnLiq3cN7FDi3EQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvuddguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepofgfggfkfffhvffutgesthdtre
    dtreertdenucfhrhhomhepfdevohhlihhnucghrghlthgvrhhsfdcuoeifrghlthgvrhhs
    sehvvghrsghumhdrohhrgheqnecuffhomhgrihhnpehlfihnrdhnvghtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpeifrghlthgvrhhssehvvghrsghumhdrohhrghenucevlhhushht
    vghrufhiiigvpedt
X-ME-Proxy: <xmx:nb_FXfXM8z2Lw1qHBPJtXL5Ggb3zqGJyCAL6bMJhkOeow2e2vEoImQ>
    <xmx:nb_FXafEWcE3fJxOl4ecxQ6yGRS24HxXwLyWlPJ_fsg7BRNxezZ_1Q>
    <xmx:nb_FXcNkTveNC71VHlr3iz8MXb1RnnkcBGdCfG-k2km7Lh_vJ6sbNQ>
    <xmx:nb_FXaeg35MrNvcqQSx1cqSbRCdfxIdOiPYbuizZVmqkJAz0UOqULQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id E66AE684005F; Fri,  8 Nov 2019 14:18:52 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-509-ge3ec61c-fmstable-20191030v1
Mime-Version: 1.0
Message-Id: <696354c2-5d7a-4f37-93d2-9a58845ad22d@www.fastmail.com>
Date:   Fri, 08 Nov 2019 14:18:32 -0500
From:   "Colin Walters" <walters@verbum.org>
To:     linux-fscrypt@vger.kernel.org
Subject: Some questions/thoughts on fs-verity
Content-Type: text/plain
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

It's clear that the Linux kernel is widely deployed with things like dm-verity devices where the user of the device isn't root.  There are great security properties from this in ensuring malicious code (compromised apps/OS) can't persist, and what Google is doing with ChromeOS/Android is a good example.

However, for cases where the user *is* root (or, like me as an OS vendor trying to support an OS where the user can be root), dm-verity comes with a whole host of restrictions and issues.  This was noted in the earlier fs-verity discussions.  Among other ones, simply trying to commit to a partition size beyond which the trusted OS cannot grow is seriously ugly.  Another example here is with ostree (or other filesystem-level tools) it's easy to have *three* images (or really N) so that while you're downloading updates you don't lose your rollback, etc.

I'm excited about the potential of fs-verity because it's so much more *flexible* - leaving aside the base OS case for a second - for example fs-verity is even available to unprivileged users by default, so if the admin has at least enabled the `verity` flag, if a user wanted to they could enable fs-verity for e.g. their `~/.bashrc`.  That's neat!

However, this gets into some questions I have around the security properties of fs-verity because - it only covers file contents.  There are many problems from this:

 - Verifying directories and symlinks is really desirable too; take e.g. /etc/systemd/system - I want to verify not just that the unit files there are valid, but also that there's no malicious ones.  
 - Being able to e.g. `chown root:root` `chmod u+s` a fs-verity protected binary is...not desired.
 - Finally, taking the scenario of a malicious code that has gained CAP_SYS_ADMIN and the ability to write to raw block devices, it seems to me that the discussions around "untrusted filesystems" (https://lwn.net/Articles/755593/) come to the fore.

In contrast because dm-verity is sealing up *everything* at the fs level, all of the above are avoided.  But it's obviously far less flexible...

(This discussion of course mirrors fs-crypt versus dm-crypt too)

I guess my concrete question here is: Are there any plans around extending fs-verity to address any of this?  Which I know given the current developers probably mostly boils down to a future Android/ChromeOS architecture question, but I think fs-verity has the potential to be used beyond just that if it isn't already.

Would love to discuss with any other distributions/update system developers etc. that are also looking at fs-verity!

