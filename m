Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A16E1A487F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Apr 2020 18:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgDJQaQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Apr 2020 12:30:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgDJQaQ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Apr 2020 12:30:16 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C25E420769;
        Fri, 10 Apr 2020 16:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586536215;
        bh=mblgBIEVUdRUB3YeIR84ZJ9DvivdoliD7Ho4kcR7p+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YF4NN7mRivStmdXCUIGEXR+Z7VMUKEnd7gMErzr2r8rhy9yyottZmnaVC2ZBwL3t/
         UhUqoOzhmVxXCPMwLgx0sb4gFIV8u3Eyyna9JVbF3ZSzjPdY8+L+nwQ/nCM3lRqaMA
         tTeffSnsk0NDB+RnUO4oEb/cSE74tucnHWPE0eU0=
Date:   Fri, 10 Apr 2020 09:30:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 1/4] tune2fs: prevent changing UUID of fs with
 stable_inodes feature
Message-ID: <20200410163014.GA112087@gmail.com>
References: <20200401203239.163679-1-ebiggers@kernel.org>
 <20200401203239.163679-2-ebiggers@kernel.org>
 <C0761869-5FCD-4CC7-9635-96C18744A0F8@dilger.ca>
 <20200407053213.GC102437@sol.localdomain>
 <74B95427-9FB1-4DF8-BE75-CE099EA3A9A3@dilger.ca>
 <20200408031149.GA852@sol.localdomain>
 <AC4A8A20-E23D-4695-B127-65CBCD3A3209@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AC4A8A20-E23D-4695-B127-65CBCD3A3209@dilger.ca>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Apr 10, 2020 at 05:53:54AM -0600, Andreas Dilger wrote:
> On Apr 7, 2020, at 9:11 PM, Eric Biggers <ebiggers@kernel.org> wrote:
> > 
> > On Tue, Apr 07, 2020 at 10:18:55AM -0600, Andreas Dilger wrote:
> >> 
> >> One question though - for the data checksums it uses s_checksum_seed
> >> to generate checksums, rather than directly using the UUID itself,
> >> so that it *is* possible to change the filesystem UUID after
> >> metadata_csum is in use, without the need to rewrite all of the
> >> checksums in the filesystem.  Could the same be done for stable_inode?
> > 
> > We could have used s_encrypt_pw_salt, but from a cryptographic perspective I
> > feel a bit safer using the UUID.  ext4 metadata checksums are non-cryptographic
> > and for integrity-only, so it's not disastrous if multiple filesystems share the
> > same s_checksum_seed.  So EXT4_FEATURE_INCOMPAT_CSUM_SEED makes sense as a
> > usability improvement for people doing things with filesystem cloning.
> > 
> > The new inode-number based encryption is a bit different since it may (depending
> > on how userspace chooses keys) depend on the per-filesystem ID for cryptographic
> > purposes.  So it can be much more important that these IDs are really unique.
> > 
> > On this basis, the UUID seems like a better choice since people doing things
> > with filesystem cloning are more likely to remember to set up the UUIDs as
> > unique, vs. some "second UUID" that's more hidden and would be forgotten about.
> 
> Actually, I think the opposite is true here.  To avoid usability problems,
> users *have* to change the UUID of a cloned/snapshot filesystem to avoid
> problems with mount-by-UUID (e.g. either filesystem may be mounted randomly
> on each boot, depending on the device enumeration order).  However, if they
> try to change the UUID, that would immediately break all of the encrypted
> files in the filesystem, so that means with the stable_inode feature either:
> - a snapshot/clone of a filesystem may subtly break your system, or
> - you can't keep a snapshot/clone of such a filesystem on the same node

My concern is about security, not usability.  

If the filesystem IDs used to derive keys for inode-number based encryption
aren't unique, then ciphertext may be repeated across files.  Users wouldn't
notice this since it would be a silent bug, but it would be a cryptographic
vulnerability.  Systems need to be designed in such a way that silent
cryptographic vulnerabilities can't occur, or at least are less likely.

Using the actual UUID rather than a hidden second field encourages people to
keep the IDs unique and is simpler.

The existence of s_encrypt_pw_salt does provide some precedent to use a hidden
second field, but not much since that's intended to be used with per-file keys.
With inode-number based encryption, filesystem ID reuse is a greater concern.

One could validly argue that this is "just a theoretical issue" at the moment,
due to the limited systems on which inode-number based encryption would actually
be used (as Ted and I have described).  But the usability concerns are likewise
theoretical at the moment, for the same reason.

> 
> > Using s_encrypt_pw_salt would also have been a bit more complex, as we'd have
> > had to add fscrypt_operations to retrieve it rather than just using s_uuid --
> > remembering to generate it if unset (mke2fs doesn't set it).  We'd also have
> > wanted to rename it to something else like s_encrypt_uuid to avoid confusion as
> > it would no longer be just a password salt.
> > 
> > Anyway, we couldn't really change this now even if we wanted to, since
> > IV_INO_LBLK_64 encryption policies were already released in v5.5.
> 
> I'm not sure I buy these arguments...  We changed handling of metadata_csum
> after the fact, by checking at mount if s_checksum_seed is initialized,
> otherwise hashing s_uuid and storing if it is zero.  Storing s_checksum_seed
> proactively in the kernel and e2fsck allows users to change s_uuid if they
> have a new enough kernel without noticing that the checksums were originally
> based on s_uuid rather than the hash of it in s_checksum_seed.
> 
> I'm not sure of the details of whether s_encrypt_pw_salt is used in the
> IV_INO_LBLK_64 case or not (since it uses inode/block number as the salt?),
> but I see that the code is already initializing s_encrypt_pw_salt in the
> kernel if unset, so that is not hard to do.  It could just make a copy from
> s_uuid rather than generating a new UUID for s_encrypt_pw_salt, or for new
> filesystems it can generate a unique s_encrypt_pw_salt and only use that?
> 
> Storing a feature flag to indicate whether s_uuid or s_encrypt_pw_salt is
> used for the IV_INO_LBLK_64 case seems pretty straight forward?  Maybe any
> filesystems that are using IV_INO_LBLK_64 with s_uuid can't change the UUID,
> but a few bits and lines of code could allow any new filesystem to do so?
> If you consider that 5.5 has been out for a few months, there aren't going
> to be a lot of users of that approach, vs. the next 10 years or more.
> 
> In the end, you are the guy who has to deal with issues here, so I leave it
> to you.  I just think it is a problem waiting to happen, and preventing the
> users from shooting themselves in the foot with tune2fs doesn't mean that
> they won't have significant problems later that could easily be solved now.
> 

Sure, it wouldn't be *that* hard to add support for using s_encrypt_pw_salt
using a separate filesystem feature flag.  And it could be done after the fact.
My points are just that it would add *some* extra complexity, we already
implemented another approach that is fine for the users who would actually use
it, and the approach we implemented is more cryptographically robust so
switching to the other way wouldn't necessarily be an improvement.

- Eric
