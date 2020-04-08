Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B251A1A37
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Apr 2020 05:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgDHDLv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 Apr 2020 23:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbgDHDLv (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 Apr 2020 23:11:51 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C34B220747;
        Wed,  8 Apr 2020 03:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586315510;
        bh=5XxD3cWZgZQOX69dsEDJQAZZldcnN1/WIrdEG3sZ5Xo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vu39r3IOeUC1sdJVGaDdpi4EXyxcjt9jFLFijaCGWSrqWSifw6val55jLqq6mUwTA
         QFMoUD54Zi4pnyuF5Uj4QzNVsJl0RLY6JiFDZ0nzjshUgBeNwAHe/sJRxpV0LF3erF
         oefGT1IUvVpUefrej6nJbNuRZgMMUZliY+y6FFss=
Date:   Tue, 7 Apr 2020 20:11:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 1/4] tune2fs: prevent changing UUID of fs with
 stable_inodes feature
Message-ID: <20200408031149.GA852@sol.localdomain>
References: <20200401203239.163679-1-ebiggers@kernel.org>
 <20200401203239.163679-2-ebiggers@kernel.org>
 <C0761869-5FCD-4CC7-9635-96C18744A0F8@dilger.ca>
 <20200407053213.GC102437@sol.localdomain>
 <74B95427-9FB1-4DF8-BE75-CE099EA3A9A3@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74B95427-9FB1-4DF8-BE75-CE099EA3A9A3@dilger.ca>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Apr 07, 2020 at 10:18:55AM -0600, Andreas Dilger wrote:
> 
> > On Apr 6, 2020, at 11:32 PM, Eric Biggers <ebiggers@kernel.org> wrote:
> > 
> > On Wed, Apr 01, 2020 at 08:19:38PM -0600, Andreas Dilger wrote:
> >> On Apr 1, 2020, at 2:32 PM, Eric Biggers <ebiggers@kernel.org> wrote:
> >>> 
> >>> From: Eric Biggers <ebiggers@google.com>
> >>> 
> >>> The stable_inodes feature is intended to indicate that it's safe to use
> >>> IV_INO_LBLK_64 encryption policies, where the encryption depends on the
> >>> inode numbers and thus filesystem shrinking is not allowed.  However
> >>> since inode numbers are not unique across filesystems, the encryption
> >>> also depends on the filesystem UUID, and I missed that there is a
> >>> supported way to change the filesystem UUID (tune2fs -U).
> >>> 
> >>> So, make 'tune2fs -U' report an error if stable_inodes is set.
> >>> 
> >>> We could add a separate stable_uuid feature flag, but it seems unlikely
> >>> it would be useful enough on its own to warrant another flag.
> >> 
> >> What about having tune2fs walk the inode table checking for any inodes that
> >> have this flag, and only refusing to clear the flag if it finds any?  That
> >> takes some time on very large filesystems, but since inode table reading is
> >> linear it is reasonable on most filesystems.
> > 
> > I assume you meant to make this comment on patch 2,
> > "tune2fs: prevent stable_inodes feature from being cleared"?
> > 
> > It's a good suggestion, but it also applies equally to the encrypt, verity,
> > extents, and ea_inode features.  Currently tune2fs can't clear any of these,
> > since any inode might be using them.
> > 
> > Note that it would actually be slightly harder to implement your suggestion for
> > stable_inodes than those four existing features, since clearing stable_inodes
> > would require reading xattrs rather than just the inode flags.
> > 
> > So if I have time, I can certainly look into allowing tune2fs to clear the
> > encrypt, verity, extents, stable_inodes, and ea_inode features, by doing an
> > inode table scan to verify that it's safe.  IMO it doesn't make sense to hold up
> > this patch on it, though.  This patch just makes stable_inodes work like other
> > ext4 features.
> 
> Sure, I'm OK with this patch, since it avoids accidental breakage.
> 
> One question though - for the data checksums it uses s_checksum_seed to generate
> checksums, rather than directly using the UUID itself, so that it *is* possible
> to change the filesystem UUID after metadata_csum is in use, without the need
> to rewrite all of the checksums in the filesystem.  Could the same be done for
> stable_inode?
> 

We could have used s_encrypt_pw_salt, but from a cryptographic perspective I
feel a bit safer using the UUID.  ext4 metadata checksums are non-cryptographic
and for integrity-only, so it's not disastrous if multiple filesystems share the
same s_checksum_seed.  So EXT4_FEATURE_INCOMPAT_CSUM_SEED makes sense as a
usability improvement for people doing things with filesystem cloning.

The new inode-number based encryption is a bit different since it may (depending
on how userspace chooses keys) depend on the per-filesystem ID for cryptographic
purposes.  So it can be much more important that these IDs are really unique.

On this basis, the UUID seems like a better choice since people doing things
with filesystem cloning are more likely to remember to set up the UUIDs as
unique, vs. some "second UUID" that's more hidden and would be forgotten about.

Using s_encrypt_pw_salt would also have been a bit more complex, as we'd have
had to add fscrypt_operations to retrieve it rather than just using s_uuid --
remembering to generate it if unset (mke2fs doesn't set it).  We'd also have
wanted to rename it to something else like s_encrypt_uuid to avoid confusion as
it would no longer be just a password salt.

Anyway, we couldn't really change this now even if we wanted to, since
IV_INO_LBLK_64 encryption policies were already released in v5.5.

- Eric
