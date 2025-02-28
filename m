Return-Path: <linux-fscrypt+bounces-620-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CCD90A49883
	for <lists+linux-fscrypt@lfdr.de>; Fri, 28 Feb 2025 12:42:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CC8D1897D67
	for <lists+linux-fscrypt@lfdr.de>; Fri, 28 Feb 2025 11:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC63025DAE8;
	Fri, 28 Feb 2025 11:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GVxBdzun"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D04B25D91B
	for <linux-fscrypt@vger.kernel.org>; Fri, 28 Feb 2025 11:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740742966; cv=none; b=LTuotHnWcPDZjJ29ThAv4JZ9XTx32+QYZ5zde0dIJT0TbpZ7v9yYIwIvUj67VomOeRFLe0i+flPUZnH8FJ7WTl+p4RpR2JlXfs8Ohar2j2K17AN6wa8pcO/ZSUP4Joz8CL+Pbd1SpU659BpXs9MwKbgcrIi15N1f2fU5KXlHzKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740742966; c=relaxed/simple;
	bh=zm4qBMT8UFprPHJJlyRd756jPaQIDuEc6Szi4aWXVmg=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=OiyLpfRoZozV3jR/JQZ75F3D1B2KkiAlpEpZ3vuUedLNNBG74/NeIAfPR7f9KKCNdSXgiW/cDJTy/jT9oMF3sM+RYwQSLvf/lsCCUnwLim6ZRb6gsxAznKVehUWH7hWPWd71tuAdcCEr3CtYTZ73pFUQvgf6g6UBNaFbO5b9eYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GVxBdzun; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740742963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=r4m6AKVLj2IbPF6kQhowg2Em0HR/Z7r0DbfEThY36Yw=;
	b=GVxBdzunVyzqa9KOiILdh++geQfanwrwyq29MqYR1EyxJ+wSY5cY/Hsw+KWPX5IIjrhTbf
	LFGqaupXf8EHaC8ZhTfGD7t69to9n1Btz2eW58XARoFauUKwhUVTfmr7oYUQyJ8BLWX56k
	34Z1SuBk2or4EAMFMQu4KNSQOb+iE+Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-DgesVJFlNmqzp43Jc2HQQA-1; Fri,
 28 Feb 2025 06:42:39 -0500
X-MC-Unique: DgesVJFlNmqzp43Jc2HQQA-1
X-Mimecast-MFC-AGG-ID: DgesVJFlNmqzp43Jc2HQQA_1740742958
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 166DA1800878;
	Fri, 28 Feb 2025 11:42:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.200])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E23D219560AE;
	Fri, 28 Feb 2025 11:42:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: afs3-standardization@openafs.org
cc: dhowells@redhat.com, jaltman@auristor.com, openafs-devel@openafs.org,
    linux-afs@lists.infradead.org, linux-fscrypt@vger.kernel.org
Subject: RFE: Support for client-side content encryption in AFS
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3324491.1740742953.1@warthog.procyon.org.uk>
Date: Fri, 28 Feb 2025 11:42:34 +0000
Message-ID: <3324492.1740742954@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Hi,

I would like to build support for file content encryption in the kAFS
filesystem driver in the Linux kernel - but this needs standardising so that
other AFS filesystems can make use of it also.

Note that by "content encryption", I mean that only the permitted clients have
a key to the content.  The server does not.  Further, filenames may also be
encrypted.

For the kAFS filesystem, content encryption would be provided by the netfs
library.  The intention is that netfslib will provide such service to any
filesystem that uses it (afs, 9p, cifs and, hopefully soon, ceph) using Linux
fscrypt where possible (but not mandatory).  netfslib would then store the
encrypted content in the local cache also and only decrypt it when it's
brought into memory.

Now, the way I would envision this working is:

 (1) Each file is divided into units of 4KiB, each of which is encrypted
     separately with its own block key.  The block key is derived from the
     file key and the block offset.

 (2) Unfortunately, AFS does not have anywhere to store additional information
     for a file, such as xattrs, but the last block must be rounded out to at
     least the crypto block size and maybe the unit size - and we need to
     stash the real file size somewhere.  There are a number of ways this
     could be dealt with:

     (a) Store this extra metadata in a separate file.  This has a potential
     	 integrity issue if we fail to update that due to EDQUOT/ENOSPC,
     	 network loss, etc.

     (b) Round up the data part of the file to 4KiB and tack on a trailer at
     	 the end of file that has the real EOF in it.  This the advantages
     	 that the trailer and the last block can be updated in a single
     	 StoreData RPC and that the real EOF can be encrypted, but the
     	 disadvantage that we can't return accurate info with stat() unless we
     	 can read (and decrypt) the trailer - and we have to do that in
     	 stat().

     (c) Stick a fixed-len trailer at the real EOF and just encrypt over part
     	 of that.  Again, this can be updated in a single StoreData RPC and
     	 the real EOF can be calculated by simple subtraction.  The trailer
     	 only need be one crypto block (say 16 bytes) in size, not the full
     	 4K.

     (d) Find a hole somewhere in the protocol and the on-server-disk metadata
     	 to store a number in the range 0-4095 that is backed up and
     	 transferred during a volume release.  I suspect this is infeasible.

     (e) Provide xattr support.  Probably also infeasible - though it might
     	 help with other things such as stacked filesystem support.

 (3) Mark a whole volume as being content-encrypted.  That is that content
     encryption is only available on a whole-volume basis unless we can find a
     way to mark individual vnodes as being encrypted - but this has the same
     issues as storing the real EOF length.

     This could be done in a number of ways:

     (a) A volume flag, passed to the client through the VLDB and the volume
     	 server.  The flag would need to be passed on to clone volumes and
     	 would need to be set at volume creation time or shortly thereafter.

	 This might need a new RPC, say VOLSER.CreateEncryptedVolume, as
	 VOLSER.CreateVolume doesn't seem to offer a way to indicate this, but
	 maybe VOLSER.SetFlags would suffice: you turn it on and everything is
	 suddenly encrypted.

     (b) Storing a magic file in the root directory of the volume
     	 (".afs_encrypted" say) that the client can look for.  This file could
     	 contain info about the algorithms used and the information about key
     	 needed to decrypt it.

 (4) Encrypt filenames in an encrypted directory.  Whilst we could just
     directly pass encrypted filenames in the protocol as the names are XDR
     strings with a length count, they can't be stored in the standard AFS
     directory format as they may include NUL and '/'.  I can see two
     possibilities here:

     (a) base64 encode the encrypted filenames (using a modified base64 to
     	 exclude '/').  This has two disadvantages: it reduces the maximum
     	 name length by 3/4 and makes all names longer, reducing the capacity
     	 of the directory.

     (b) Use the key to generate a series of numbers and then use each number
     	 to map a character of the filename, being careful to break the range
     	 around 0 and 47 so that we can map backwards.  This may result in
     	 less secure filename encryption than (a) and is trickier to do.

 (5) Derive file keys by combining a per-volume key with the vnode ID and the
     uniquifier.  Marking files with the 'name' of a specific key could be
     possible, but again this requires somewhere to store these as discussed
     in (2).

     Possibly 'file keys' could be skipped, deriving each block key from:

	RW vol ID || vnode ID || uniquifier || block pos

     The cell name cannot be included due to aliasing unless the canonical
     cell name can be queried.

 (6) Provide a conditional FS.StoreData RPC that takes a Data Version number
     as an additional parameter and fails if that doesn't match the current
     DV.  The issue is that even if just a byte is changed, an entire crypto
     unit must be written and truncation may also have to reencrypt the tail.

     (And by "fail", I'd prefer if it returned the updated stats rather than
     simply aborting - but I understand that we really want to close off the
     data transmission).

 (7) Though it's not strictly required for this, similar to (6), a conditional
     FS.FetchData could be useful as well for speculatively reading from a RO
     clone of a RW volume.

     Again, rather than failing with an abort, I'd prefer this to return no
     data and just the updated stats.  The client should then check the DV in
     the updated stats.

The simplest way to do this need not involve any changes on the server, though
having a conditional store would make it safer.

Thanks for your consideration,
David


