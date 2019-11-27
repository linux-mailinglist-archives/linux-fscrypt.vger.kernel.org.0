Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBA610C076
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 Nov 2019 23:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfK0W6C (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 27 Nov 2019 17:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727614AbfK0W6C (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 27 Nov 2019 17:58:02 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CFF02158A;
        Wed, 27 Nov 2019 22:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574895481;
        bh=t3udkCyJ2+MbQy+Z9Qp0o57cXv0Q9HyyU13vVE5dUQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Deo/NFja3Ec/iEpHsMVqKdwZVOB5gZqTJi2hjqlmoJsTFDWmlOLbvzV3X7LPyDphP
         Ms8zbsvj56T1mZ6OnHtT+QRnj9cJ4EFpVyogpcxAZIhdHecHMkTEFlIa4JBQRSHK3i
         SzMH3cM0I2ptzWcMNEyqaxez08YhmzctQ8rnC2Eg=
Date:   Wed, 27 Nov 2019 14:57:59 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] xfstests: test adding filesystem-level fscrypt
 key via key_id
Message-ID: <20191127225759.GA303989@sol.localdomain>
References: <20191119223130.228341-1-ebiggers@kernel.org>
 <20191127204536.GA12520@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127204536.GA12520@linux.intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 27, 2019 at 10:45:36PM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 19, 2019 at 02:31:27PM -0800, Eric Biggers wrote:
> > This series adds a test which tests adding a key to a filesystem's
> > fscrypt keyring via an "fscrypt-provisioning" keyring key.  This is an
> > alternative to the normal method where the raw key is given directly.
> > 
> > I'm sending this out for comment, but it shouldn't be merged until the
> > corresponding kernel patch has reached mainline.  For more details, see
> > the kernel patch:
> > https://lkml.kernel.org/linux-fscrypt/20191119222447.226853-1-ebiggers@kernel.org/T/#u
> > 
> > This test depends on an xfs_io patch which adds the '-k' option to the
> > 'add_enckey' command, e.g.:
> > 
> > 	xfs_io -c "add_enckey -k KEY_ID" MOUNTPOINT
> > 
> > This test is skipped if the needed kernel or xfs_io support is absent.
> > 
> > This has been tested on ext4, f2fs, and ubifs.
> > 
> > To apply cleanly, my other xfstests patch series
> > "[RFC PATCH 0/5] xfstests: verify ciphertext of IV_INO_LBLK_64 encryption policies"
> > must be applied first.
> > 
> > This series can also be retrieved from
> > https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git
> > tag "fscrypt-provisioning_2019-11-19".
> > 
> > Eric Biggers (3):
> >   common/rc: handle option with argument in _require_xfs_io_command()
> >   common/encrypt: move constant test key to common code
> >   generic: test adding filesystem-level fscrypt key via key_id
> > 
> >  common/encrypt        |  95 +++++++++++++++++++++----
> >  common/rc             |   2 +-
> >  tests/generic/580     |  17 ++---
> >  tests/generic/806     | 156 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/806.out |  73 ++++++++++++++++++++
> >  tests/generic/group   |   1 +
> >  6 files changed, 316 insertions(+), 28 deletions(-)
> >  create mode 100644 tests/generic/806
> >  create mode 100644 tests/generic/806.out
> > 
> > -- 
> > 2.24.0.432.g9d3f5f5b63-goog
> > 
> 
> I'm newbie with fscrypt so I started by encrypting a directory without
> the new feature
> 
> sudo tune2fs -O encrypt /dev/sda2
> sudo fscrypt setup /
> fscrypt encrypt foo
> 
> Worked.
> 
> Generally speaking I'd appreciate a usage example like here to the
> commit message:
> 
> https://lwn.net/Articles/692514/
> 
> Is this doable?
> 
> I might consider trying out the XFS test suite some day but right now it
> would be first nice to smoke test the feature quickly.
> 
> I think for this patch that would actually be mostly sufficient testing.
> 

You could manually do what the xfstest does, which is more or less the following
(requires xfs_io patched with https://patchwork.kernel.org/patch/11252795/):

	mkfs.ext4 -O encrypt /dev/vdc
	mount /dev/vdc /vdc
	keyctl new_session
	payload='\x02\x00\x00\x00\x00\x00\x00\x00'
	for i in {1..64}; do
		payload+="\\x$(printf "%02x" $i)"
	done
	keyid=$(echo -ne "$payload" | keyctl padd fscrypt-provisioning desc @s)
	keyspec=$(xfs_io -c "add_enckey -k $keyid" /vdc | awk '{print $NF}')
	mkdir /vdc/edir
	xfs_io -c "set_encpolicy $keyspec" /vdc/edir
	echo contents > /vdc/edir/file

I'm not yet planning to use this feature in the 'fscrypt' userspace tool
https://github.com/google/fscrypt.  The user who actually wants this feature
(Android) isn't using the 'fscrypt' tool, but rather is using custom code.

Also, the 'fscrypt' tool isn't meant for testing or exposing every corner of the
fscrypt kernel API.  Rather, it's meant to be a user-friendly tool for creating
encrypted directories on "regular" Linux distros, supporting lots of higher
level userspace features like passphrase hashing with Argon2, multiple
protectors, and auto-unlocking directories with PAM.

So for now, the important thing is to have an xfstest that fully tests this new
API.  For that, like the other fscrypt tests, I'm using keyctl and xfs_io to
access the kernel API directly.

Later, if people really need the 'fscrypt' tool to do something that requires
this feature, we can add it.  This would likely take the form of a user-friendly
option to 'fscrypt unlock' rather than a direct translation of the kernel API.

- Eric
