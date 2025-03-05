Return-Path: <linux-fscrypt+bounces-626-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05529A4F4A6
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Mar 2025 03:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2504D16C174
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Mar 2025 02:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82AF65103F;
	Wed,  5 Mar 2025 02:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jxLpvpKH"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB1CBA33
	for <linux-fscrypt@vger.kernel.org>; Wed,  5 Mar 2025 02:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741141435; cv=none; b=ZlCIJdMT5OFFiwl60V8nwBd57ZP0H0rtlTe8/DLbkbwMylIq/avzKAezts0sEgPR04M8R+o8ww00Rr3KYFX6/NT830DlKV/y5kkWLSjTg961fz7JgeI7GNxgr5FKwLYWOD0Z1hUdp19yTUaDK2ZcFckFPKbqyD84HnQcmhFaPnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741141435; c=relaxed/simple;
	bh=nDnQM6gCuBkac8UVfMzzEVxLrhjy4Iz8xyNfM+10cHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gJa5RSoBlenI6bFLYwjyqy7xRm1hTEpPEEYJBpCHqul93accgd4HoAZzJrUTglD3dIbxCACh4jr1lSonPTV5UkhgQViDmmJPzjWZJTzPtcAd3xsa2/bb3ClsVSRxL5ZyRyqsCRBgpBtVahnrshRe6irVJG40qlnIo1FPJqrdAQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jxLpvpKH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6F7C4CEEE;
	Wed,  5 Mar 2025 02:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741141434;
	bh=nDnQM6gCuBkac8UVfMzzEVxLrhjy4Iz8xyNfM+10cHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jxLpvpKHzqRDNhVRb3YYHLA+bWF0dY1HRaXS8QaZ/c0AF/nysOVQnu8+SVY06YTad
	 vf4Idd/UQGzFT46lKYF6OXzm1ehXw1owGIn1MdYuVKp1Pzmw+ak9i60xudFqGhMtwv
	 9Gdj9Wq06aqFgmqzaAQxVadT5PFlKB/cFrgHdZk1WHl1Vv9h4Ms78AASEN6u2/+/Fh
	 0JIUDjg5iAWXWWoltr0Jlxvmq7XosFI2IqpeVouwF9yvailMEgY0+f47hsu33p+3hL
	 hj7XaxrwtsYXnTCIcFEvrWJjeNhnV70aHp3+9PkTUnqAKdR2Uv02sRG7pdm4bZcxqT
	 JpedsyK8mbetw==
Date: Tue, 4 Mar 2025 18:23:53 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: afs3-standardization@openafs.org, jaltman@auristor.com,
	openafs-devel@openafs.org, linux-afs@lists.infradead.org,
	linux-fscrypt@vger.kernel.org
Subject: Re: RFE: Support for client-side content encryption in AFS
Message-ID: <20250305022353.GB20133@sol.localdomain>
References: <3324492.1740742954@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3324492.1740742954@warthog.procyon.org.uk>

On Fri, Feb 28, 2025 at 11:42:34AM +0000, David Howells wrote:
> Hi,
> 
> I would like to build support for file content encryption in the kAFS
> filesystem driver in the Linux kernel - but this needs standardising so that
> other AFS filesystems can make use of it also.
> 
> Note that by "content encryption", I mean that only the permitted clients have
> a key to the content.  The server does not.  Further, filenames may also be
> encrypted.
> 
> For the kAFS filesystem, content encryption would be provided by the netfs
> library.  The intention is that netfslib will provide such service to any
> filesystem that uses it (afs, 9p, cifs and, hopefully soon, ceph) using Linux
> fscrypt where possible (but not mandatory).  netfslib would then store the
> encrypted content in the local cache also and only decrypt it when it's
> brought into memory.
> 
> Now, the way I would envision this working is:
> 
>  (1) Each file is divided into units of 4KiB, each of which is encrypted
>      separately with its own block key.  The block key is derived from the
>      file key and the block offset.
> 
>  (2) Unfortunately, AFS does not have anywhere to store additional information
>      for a file, such as xattrs, but the last block must be rounded out to at
>      least the crypto block size and maybe the unit size - and we need to
>      stash the real file size somewhere.  There are a number of ways this
>      could be dealt with:
> 
>      (a) Store this extra metadata in a separate file.  This has a potential
>      	 integrity issue if we fail to update that due to EDQUOT/ENOSPC,
>      	 network loss, etc.
> 
>      (b) Round up the data part of the file to 4KiB and tack on a trailer at
>      	 the end of file that has the real EOF in it.  This the advantages
>      	 that the trailer and the last block can be updated in a single
>      	 StoreData RPC and that the real EOF can be encrypted, but the
>      	 disadvantage that we can't return accurate info with stat() unless we
>      	 can read (and decrypt) the trailer - and we have to do that in
>      	 stat().
> 
>      (c) Stick a fixed-len trailer at the real EOF and just encrypt over part
>      	 of that.  Again, this can be updated in a single StoreData RPC and
>      	 the real EOF can be calculated by simple subtraction.  The trailer
>      	 only need be one crypto block (say 16 bytes) in size, not the full
>      	 4K.
> 
>      (d) Find a hole somewhere in the protocol and the on-server-disk metadata
>      	 to store a number in the range 0-4095 that is backed up and
>      	 transferred during a volume release.  I suspect this is infeasible.
> 
>      (e) Provide xattr support.  Probably also infeasible - though it might
>      	 help with other things such as stacked filesystem support.
> 
>  (3) Mark a whole volume as being content-encrypted.  That is that content
>      encryption is only available on a whole-volume basis unless we can find a
>      way to mark individual vnodes as being encrypted - but this has the same
>      issues as storing the real EOF length.
> 
>      This could be done in a number of ways:
> 
>      (a) A volume flag, passed to the client through the VLDB and the volume
>      	 server.  The flag would need to be passed on to clone volumes and
>      	 would need to be set at volume creation time or shortly thereafter.
> 
> 	 This might need a new RPC, say VOLSER.CreateEncryptedVolume, as
> 	 VOLSER.CreateVolume doesn't seem to offer a way to indicate this, but
> 	 maybe VOLSER.SetFlags would suffice: you turn it on and everything is
> 	 suddenly encrypted.
> 
>      (b) Storing a magic file in the root directory of the volume
>      	 (".afs_encrypted" say) that the client can look for.  This file could
>      	 contain info about the algorithms used and the information about key
>      	 needed to decrypt it.
> 
>  (4) Encrypt filenames in an encrypted directory.  Whilst we could just
>      directly pass encrypted filenames in the protocol as the names are XDR
>      strings with a length count, they can't be stored in the standard AFS
>      directory format as they may include NUL and '/'.  I can see two
>      possibilities here:
> 
>      (a) base64 encode the encrypted filenames (using a modified base64 to
>      	 exclude '/').  This has two disadvantages: it reduces the maximum
>      	 name length by 3/4 and makes all names longer, reducing the capacity
>      	 of the directory.
> 
>      (b) Use the key to generate a series of numbers and then use each number
>      	 to map a character of the filename, being careful to break the range
>      	 around 0 and 47 so that we can map backwards.  This may result in
>      	 less secure filename encryption than (a) and is trickier to do.
> 
>  (5) Derive file keys by combining a per-volume key with the vnode ID and the
>      uniquifier.  Marking files with the 'name' of a specific key could be
>      possible, but again this requires somewhere to store these as discussed
>      in (2).
> 
>      Possibly 'file keys' could be skipped, deriving each block key from:
> 
> 	RW vol ID || vnode ID || uniquifier || block pos
> 
>      The cell name cannot be included due to aliasing unless the canonical
>      cell name can be queried.
> 
>  (6) Provide a conditional FS.StoreData RPC that takes a Data Version number
>      as an additional parameter and fails if that doesn't match the current
>      DV.  The issue is that even if just a byte is changed, an entire crypto
>      unit must be written and truncation may also have to reencrypt the tail.
> 
>      (And by "fail", I'd prefer if it returned the updated stats rather than
>      simply aborting - but I understand that we really want to close off the
>      data transmission).
> 
>  (7) Though it's not strictly required for this, similar to (6), a conditional
>      FS.FetchData could be useful as well for speculatively reading from a RO
>      clone of a RW volume.
> 
>      Again, rather than failing with an abort, I'd prefer this to return no
>      data and just the updated stats.  The client should then check the DV in
>      the updated stats.
> 
> The simplest way to do this need not involve any changes on the server, though
> having a conditional store would make it safer.
> 

I haven't had a chance to look at this in detail, but a couple things:

First, CephFS already supports fscrypt.  Have you looked at how it works and
solves some of these issues?

Second, per-block keys would be really inefficient and are unnecessary.  The way
that fscrypt works is that the keys are (usually) per-file, and within each file
each block has a different IV (initialization vector).  That is sufficient to
make each block be encrypted differently.

- Eric

