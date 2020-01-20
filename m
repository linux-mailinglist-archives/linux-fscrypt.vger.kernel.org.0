Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50CC142193
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Jan 2020 03:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgATCVE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 19 Jan 2020 21:21:04 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56163 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728874AbgATCVD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 19 Jan 2020 21:21:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579486862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qVu9q986LuNyNKwrEDimdMNGWStikF2Ba4yVaUees/8=;
        b=RCwrjdEVbLLoAlzR2zzPpslsnrQis5vY9G78x4c6tWx2lYKjlIU/KXZJdEnGIC1iFwWDp6
        hjMgY6BM9yEjefQPYxyz6px7172T3D6C1b18cKXjsghvsCK+WqMllvTItxztbgOzkk6qXE
        Y40sy3+KiRI1WLKmzMAvKW6kBX+CbLU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-McSD059pORCmIFLezXmLLg-1; Sun, 19 Jan 2020 21:21:00 -0500
X-MC-Unique: McSD059pORCmIFLezXmLLg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C81E3185432C;
        Mon, 20 Jan 2020 02:20:59 +0000 (UTC)
Received: from localhost (dhcp-12-196.nay.redhat.com [10.66.12.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4599D1A7E4;
        Mon, 20 Jan 2020 02:20:59 +0000 (UTC)
Date:   Mon, 20 Jan 2020 10:20:57 +0800
From:   Murphy Zhou <xzhou@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Murphy Zhou <xzhou@redhat.com>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 6/9] generic: add test for non-root use of fscrypt API
 additions
Message-ID: <20200120022057.6bgrpd5iu34455ty@xzhoux.usersys.redhat.com>
References: <20191015181643.6519-1-ebiggers@kernel.org>
 <20191015181643.6519-7-ebiggers@kernel.org>
 <20200119054515.3mxrpky7fiegnj5s@xzhoux.usersys.redhat.com>
 <20200119182542.GA913@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200119182542.GA913@sol.localdomain>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jan 19, 2020 at 10:25:42AM -0800, Eric Biggers wrote:
> On Sun, Jan 19, 2020 at 01:45:15PM +0800, Murphy Zhou wrote:
> > Hi Eric,
> > 
> > On Tue, Oct 15, 2019 at 11:16:40AM -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Test non-root use of the fscrypt filesystem-level encryption keyring and
> > > v2 encryption policies.
> > 
> > This testcase now fails on latest Linus tree with latest e2fsprogs
> > on ext4:
> > 
> > FSTYP         -- ext4
> > PLATFORM      -- Linux/x86_64 dell-pesc430-01 5.4.0+ #1 SMP Mon Nov 25 16:40:55 EST 2019
> > MKFS_OPTIONS  -- /dev/sda3
> > MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:nfs_t:s0 /dev/sda3 /mnt/xfstests/mnt2
> > generic/581	- output mismatch (see /var/lib/xfstests/results//generic/581.out.bad)
> >     --- tests/generic/581.out	2019-11-25 20:30:04.536051638 -0500
> >     +++ /var/lib/xfstests/results//generic/581.out.bad	2019-11-26 01:04:17.318332220 -0500
> >     @@ -33,7 +33,7 @@
> >      Added encryption key
> >      Added encryption key
> >      Added encryption key
> >     -Error adding encryption key: Disk quota exceeded
> >     +Added encryption key
> >      
> >      # Adding key as root
> > ...
> > 
> > A rough looking back shows that this probably started since your fscrypt
> > update for 5.5, added support for IV_INO_LBLK_64 encryption policies.
> > 
> > I guess you are aware of this :-)
> > 
> 
> Nope, this has been passing for me.  I don't see how this can have anything to
> do with the fscrypt update for 5.5.  I'm guessing this is a race condition in
> the test caused by the kernel's keyrings subsystem reclaiming the keys quota
> asynchronously.  I'll see if I can find a way to reproduce it and make the test
> more reliable.

OK, Thanks for the info. I'll try to bisect.

> 
> - Eric
> 

