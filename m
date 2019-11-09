Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F1CF5D3A
	for <lists+linux-fscrypt@lfdr.de>; Sat,  9 Nov 2019 04:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfKIDlx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 8 Nov 2019 22:41:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbfKIDlx (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 8 Nov 2019 22:41:53 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C41E21019;
        Sat,  9 Nov 2019 03:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573270912;
        bh=nM7gdcItKIGEBk0xEwwAqP80Fel3Rlr173boiqOMR8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I643OoiRvnVlCe9L18octupHW4bqtDJH/GNba+l5qYsYWILut8wlYaNbMFXqSDbQR
         jp9wQoJV2pQdBHeCBTxCzUjlyCbb592osUTSMM3NeCMiXUk1iUtdC/qE+GpvwteA/4
         DF0KwhB8WmUXiO3l+45bTPxYctPb0ZgFTwf3eatk=
Date:   Fri, 8 Nov 2019 19:41:50 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Colin Walters <walters@verbum.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: Some questions/thoughts on fs-verity
Message-ID: <20191109034150.GC9739@sol.localdomain>
Mail-Followup-To: Colin Walters <walters@verbum.org>,
        linux-fscrypt@vger.kernel.org
References: <696354c2-5d7a-4f37-93d2-9a58845ad22d@www.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <696354c2-5d7a-4f37-93d2-9a58845ad22d@www.fastmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Colin,

On Fri, Nov 08, 2019 at 02:18:32PM -0500, Colin Walters wrote:
> It's clear that the Linux kernel is widely deployed with things like dm-verity devices where the user of the device isn't root.  There are great security properties from this in ensuring malicious code (compromised apps/OS) can't persist, and what Google is doing with ChromeOS/Android is a good example.
> 
> However, for cases where the user *is* root (or, like me as an OS vendor trying to support an OS where the user can be root), dm-verity comes with a whole host of restrictions and issues.  This was noted in the earlier fs-verity discussions.  Among other ones, simply trying to commit to a partition size beyond which the trusted OS cannot grow is seriously ugly.  Another example here is with ostree (or other filesystem-level tools) it's easy to have *three* images (or really N) so that while you're downloading updates you don't lose your rollback, etc.
> 
> I'm excited about the potential of fs-verity because it's so much more *flexible* - leaving aside the base OS case for a second - for example fs-verity is even available to unprivileged users by default, so if the admin has at least enabled the `verity` flag, if a user wanted to they could enable fs-verity for e.g. their `~/.bashrc`.  That's neat!
> 
> However, this gets into some questions I have around the security properties of fs-verity because - it only covers file contents.  There are many problems from this:
> 
>  - Verifying directories and symlinks is really desirable too; take e.g. /etc/systemd/system - I want to verify not just that the unit files there are valid, but also that there's no malicious ones.  
>  - Being able to e.g. `chown root:root` `chmod u+s` a fs-verity protected binary is...not desired.
>  - Finally, taking the scenario of a malicious code that has gained CAP_SYS_ADMIN and the ability to write to raw block devices, it seems to me that the discussions around "untrusted filesystems" (https://lwn.net/Articles/755593/) come to the fore.
> 

Can you take a step back and consider what security properties you're actually
trying to achieve?  In particular, be aware that if you just enable fs-verity on
a file but never actually compare the hash to anything, it provides integrity
only (detection of accidental corruption), not any authenticity protection.

In your pull request to OSTree (https://github.com/ostreedev/ostree/pull/1959),
I see a call to FS_IOC_ENABLE_VERITY.  But there's no corresponding call to
FS_IOC_MEASURE_VERITY to actually authenticate the file(s), nor is fs-verity's
built-in signature verification feature being used.  So this is integrity-only;
there's no protection against malicious modifications to the data on-disk.

I.e., fs-verity is really meant to be used as part of a userspace-driven
authentication policy.  It's not something that magically increases security by
itself.  That's partly why the scope of fs-verity is limited to file contents:
userspace can still authenticate other metadata if needed.

As for an attacker exploiting a filesystem bug, yes that is a big problem
currently in Linux.  However, gaining code execution via such a bug is a *bug*
and is patchable and mitigable, whereas gaining code execution by modifying
unauthenticated code stored on-disk is simply working as intended.

- Eric
