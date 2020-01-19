Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F38D9141F52
	for <lists+linux-fscrypt@lfdr.de>; Sun, 19 Jan 2020 19:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgASSZp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 19 Jan 2020 13:25:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgASSZp (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 19 Jan 2020 13:25:45 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5441620674;
        Sun, 19 Jan 2020 18:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579458344;
        bh=zQZdqDeuWbNbPpCdXf5Ch3zYDAXZ97H8bl/7Br8CJNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j1FTRC554mfLcYQFv5j7GMePr9aDGp/PS9E2kfaOxBqotGo4Fdvzqh9Lz2PUC3McU
         zZ1waBYbm8TH+G6I6OjLsZqWVa1QxNQGIItk0gCKbJpPlpsjq2ZEej/xLh6mmWck7t
         4ZOSBaXuNfxkQB2At09Di5kDbvjoUT3olIAniXrI=
Date:   Sun, 19 Jan 2020 10:25:42 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Murphy Zhou <xzhou@redhat.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 6/9] generic: add test for non-root use of fscrypt API
 additions
Message-ID: <20200119182542.GA913@sol.localdomain>
References: <20191015181643.6519-1-ebiggers@kernel.org>
 <20191015181643.6519-7-ebiggers@kernel.org>
 <20200119054515.3mxrpky7fiegnj5s@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200119054515.3mxrpky7fiegnj5s@xzhoux.usersys.redhat.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jan 19, 2020 at 01:45:15PM +0800, Murphy Zhou wrote:
> Hi Eric,
> 
> On Tue, Oct 15, 2019 at 11:16:40AM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Test non-root use of the fscrypt filesystem-level encryption keyring and
> > v2 encryption policies.
> 
> This testcase now fails on latest Linus tree with latest e2fsprogs
> on ext4:
> 
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 dell-pesc430-01 5.4.0+ #1 SMP Mon Nov 25 16:40:55 EST 2019
> MKFS_OPTIONS  -- /dev/sda3
> MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:nfs_t:s0 /dev/sda3 /mnt/xfstests/mnt2
> generic/581	- output mismatch (see /var/lib/xfstests/results//generic/581.out.bad)
>     --- tests/generic/581.out	2019-11-25 20:30:04.536051638 -0500
>     +++ /var/lib/xfstests/results//generic/581.out.bad	2019-11-26 01:04:17.318332220 -0500
>     @@ -33,7 +33,7 @@
>      Added encryption key
>      Added encryption key
>      Added encryption key
>     -Error adding encryption key: Disk quota exceeded
>     +Added encryption key
>      
>      # Adding key as root
> ...
> 
> A rough looking back shows that this probably started since your fscrypt
> update for 5.5, added support for IV_INO_LBLK_64 encryption policies.
> 
> I guess you are aware of this :-)
> 

Nope, this has been passing for me.  I don't see how this can have anything to
do with the fscrypt update for 5.5.  I'm guessing this is a race condition in
the test caused by the kernel's keyrings subsystem reclaiming the keys quota
asynchronously.  I'll see if I can find a way to reproduce it and make the test
more reliable.

- Eric
