Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4CB14C41E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 29 Jan 2020 01:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgA2Apq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 28 Jan 2020 19:45:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgA2Apq (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 28 Jan 2020 19:45:46 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 926DF20663;
        Wed, 29 Jan 2020 00:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580258745;
        bh=CjLApc0NvFYZVZkSpwTwdDV2rpmlmy+MjXIUnYqAFDs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jOwETRWmOMUtfzMhYA0lgB95xE4/0MZhQ20ZDCh5gR/Uiz2JlrW8cl0pXI2KcKljB
         +w2DtrZd3GF1ik+lsKQcSOs+fXAEpgatQddiKVDvv+sEaiCWhsHcmvX0qWuzsCsJ+B
         xeMHWTc66mZjCgK7YU5Hpq1U3E/Z4xkUb2KaEUx0=
Date:   Tue, 28 Jan 2020 16:45:44 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Murphy Zhou <xzhou@redhat.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 6/9] generic: add test for non-root use of fscrypt API
 additions
Message-ID: <20200129004543.GB224488@gmail.com>
References: <20191015181643.6519-1-ebiggers@kernel.org>
 <20191015181643.6519-7-ebiggers@kernel.org>
 <20200119054515.3mxrpky7fiegnj5s@xzhoux.usersys.redhat.com>
 <20200119182542.GA913@sol.localdomain>
 <20200120022057.6bgrpd5iu34455ty@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120022057.6bgrpd5iu34455ty@xzhoux.usersys.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 20, 2020 at 10:20:57AM +0800, Murphy Zhou wrote:
> On Sun, Jan 19, 2020 at 10:25:42AM -0800, Eric Biggers wrote:
> > On Sun, Jan 19, 2020 at 01:45:15PM +0800, Murphy Zhou wrote:
> > > Hi Eric,
> > > 
> > > On Tue, Oct 15, 2019 at 11:16:40AM -0700, Eric Biggers wrote:
> > > > From: Eric Biggers <ebiggers@google.com>
> > > > 
> > > > Test non-root use of the fscrypt filesystem-level encryption keyring and
> > > > v2 encryption policies.
> > > 
> > > This testcase now fails on latest Linus tree with latest e2fsprogs
> > > on ext4:
> > > 
> > > FSTYP         -- ext4
> > > PLATFORM      -- Linux/x86_64 dell-pesc430-01 5.4.0+ #1 SMP Mon Nov 25 16:40:55 EST 2019
> > > MKFS_OPTIONS  -- /dev/sda3
> > > MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:nfs_t:s0 /dev/sda3 /mnt/xfstests/mnt2
> > > generic/581	- output mismatch (see /var/lib/xfstests/results//generic/581.out.bad)
> > >     --- tests/generic/581.out	2019-11-25 20:30:04.536051638 -0500
> > >     +++ /var/lib/xfstests/results//generic/581.out.bad	2019-11-26 01:04:17.318332220 -0500
> > >     @@ -33,7 +33,7 @@
> > >      Added encryption key
> > >      Added encryption key
> > >      Added encryption key
> > >     -Error adding encryption key: Disk quota exceeded
> > >     +Added encryption key
> > >      
> > >      # Adding key as root
> > > ...
> > > 
> > > A rough looking back shows that this probably started since your fscrypt
> > > update for 5.5, added support for IV_INO_LBLK_64 encryption policies.
> > > 
> > > I guess you are aware of this :-)
> > > 
> > 
> > Nope, this has been passing for me.  I don't see how this can have anything to
> > do with the fscrypt update for 5.5.  I'm guessing this is a race condition in
> > the test caused by the kernel's keyrings subsystem reclaiming the keys quota
> > asynchronously.  I'll see if I can find a way to reproduce it and make the test
> > more reliable.
> 
> OK, Thanks for the info. I'll try to bisect.
> 

Can you check whether the test passes reliably for you if you apply
https://lkml.kernel.org/fstests/20200129004251.133747-1-ebiggers@kernel.org/?

Thanks,

- Eric
