Return-Path: <linux-fscrypt+bounces-1135-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UBCcJgKuiGkSuQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1135-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:38:42 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EEA6F1092FD
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:38:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 81F5B300A756
	for <lists+linux-fscrypt@lfdr.de>; Sun,  8 Feb 2026 15:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33050364E89;
	Sun,  8 Feb 2026 15:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="j1SkPa4j"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B5D27C84E;
	Sun,  8 Feb 2026 15:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770565120; cv=none; b=aebn6jkXhWGg8F2DUPgzqXSAeLcuhKBEMHsA6HnpGVeJgxRbQBF5940JAJYAsE7TI18xBeCwaerdhFNIibJMEU/mZZBjy2qaQq1Emn/nYxfpdcmeL1XtcWonpW/MR73uFp8fw42XJaZqy79f1a3zAcEteS/T4+jSoGWttXxIqbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770565120; c=relaxed/simple;
	bh=rFbGOiK4asqBF1nuiuOlj/Fa9Smv9xVM4rjUXxwwess=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lJh0diHg/g5bWwnjwAHMPu1HPEq9lr2/58PJGsjZEznGjJOtrsGxmpk9fxjvndy+y796K+9dldk15ePFLk76/1+Q8Pr/qyf84jTI2k+ujh5PR56pFNhnum4qyW13A98/mhQsQedmTjONYQ//XtTa6FQD3CYYMaiAx7kYUnuLDpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=j1SkPa4j; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 618EooSV2508204;
	Sun, 8 Feb 2026 07:38:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=vgTiYa6DCWh1dmbFHGBmxbiRhNPgxFQTakkCRpVvpkg=; b=j1SkPa4jEW8Z
	uG9XocBZRjCL/ko7LQGSjsXEj32orZVuPEYk1B0CXdeZZn7czZJgLADQf9GNm9Rl
	jqbGGjKqZ77kD2pkBbK8/pgfOBzhmfdhTlu2wFcaH/kIuqkPkSay0YKg+cr5kxWN
	9aU9IZ+0TcdwDG4pwwL2fahrBJ5WQJ89tIXAVbH3uFLuucg1ES0sZVaEvFQ9MYCr
	fOmCQfL7ooCtwA5sNIb6DdDeBzsWbGuA/ivd6OPezFGs105ZA702s+jp1Odk80iR
	K5hGWjs9xCPu1FhTAK8qmCn7tn9AU1Y5JCJ7Mf3LEfyXWQdXnu1fJ3WMX0cd3bwl
	Qdvx+Ob64A==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c6vm108tf-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 08 Feb 2026 07:38:30 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Sun, 8 Feb 2026 15:38:28 +0000
From: Chris Mason <clm@meta.com>
To: Daniel Vacek <neelx@suse.com>
CC: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        Eric Biggers
	<ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim
	<jaegeuk@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, David Sterba
	<dsterba@suse.com>,
        <linux-block@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Omar Sandoval <osandov@osandov.com>,
        "Sweet
 Tea Dorminy" <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH v6 11/43] btrfs: add inode encryption contexts
Date: Sun, 8 Feb 2026 07:36:25 -0800
Message-ID: <20260208153808.3476221-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206182336.1397715-12-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-12-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=ILUPywvG c=1 sm=1 tr=0 ts=6988adf6 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8 a=iox4zFpeAAAA:8 a=-uoBkjAQAAAA:8
 a=5MRvH3LrHOFhjJMh-tkA:9 a=WzC6qhA0u3u7Ye7llzcV:22 a=y0wLjPFBLyexm0soFTcm:22
X-Proofpoint-ORIG-GUID: bUWpRTI1YzB3R97-dMMAupedYNnBSO58
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDEzNCBTYWx0ZWRfX8t3Z29QcGadB
 o6+B/qf+tCbhv+rSERybkfC5xf7AhSKTF38DO+t/MbsLORfVi+12cf04AjQfN/dalM0t/rUGuhd
 jC24FtEi8Far4vwHhYWnI5HRrnsr/ZgZiqrMVgK1JbvzORDN2wSyJtib3fUCvN5aCv5JqlZmJhM
 mT0uVN8hlypSTny24TTYyxtLIdIiWtH1E1bhD/+0fOeH5a4ADyJRFLfmHW5uPRnZscagOBlI+SC
 p+X5QlSBhZkj85y7aiZrbRoLA5Bl8/7nlOjeTjLyckho64bg49yN95RqMKjcKBmms05EYaETLsG
 5lf3HRo1hB5WMTzCnsxneUZsEW/RznA7KmA1fpZsxTzQQnUlfmUOq+rZXKmfR8Mg3vgDW7bGEBq
 /rPB7HMGKBqLEtHVajJ7IDSakfRJuKG6t/Uq6LAmaN5Qd+MSU4GU7VHsoX/f8ngjbJl02ipOpGg
 mmhMDmYYsyGu4peg0Ew==
X-Proofpoint-GUID: bUWpRTI1YzB3R97-dMMAupedYNnBSO58
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_04,2026-02-05_03,2025-10-01_01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1135-lists,linux-fscrypt=lfdr.de];
	DKIM_TRACE(0.00)[meta.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clm@meta.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:mid,meta.com:dkim,suse.com:email,osandov.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EEA6F1092FD
X-Rspamd-Action: no action

Daniel Vacek <neelx@suse.com> wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> fscrypt stores a context item with encrypted inodes that contains the
> related encryption information.  fscrypt provides an arbitrary blob for
> the filesystem to store, and it does not clearly fit into an existing
> structure, so this goes in a new item type.

Hi everyone,

I'm running the btrfs for-next branch, along with the encryption patch set
through my AI review prompts:

https://github.com/masoncl/review-prompts

I'm working on some btrfs specific instructions, but hopefully these reviews
are already useful.  I've kept the headers to make it easier to double check
that I'm actually replying to the right email, but please let me know if any
parts of this are incorrect:

commit 2d6114c2937b897d844735aa16d5369e3ec6d135
Author: Omar Sandoval <osandov@osandov.com>

btrfs: add inode encryption contexts

fscrypt stores a context item with encrypted inodes that contains the
related encryption information.  fscrypt provides an arbitrary blob for
the filesystem to store, and it does not clearly fit into an existing
structure, so this goes in a new item type.

> diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
> index 6cfba7d94e726..e9b024d671a22 100644
> --- a/fs/btrfs/fscrypt.c
> +++ b/fs/btrfs/fscrypt.c

[ ... ]

> @@ -1,10 +1,126 @@
>  // SPDX-License-Identifier: GPL-2.0
>
> +#include <linux/iversion.h>
>  #include "ctree.h"
> +#include "accessors.h"
>  #include "btrfs_inode.h"
> +#include "disk-io.h"
> +#include "fs.h"
>  #include "fscrypt.h"
> +#include "ioctl.h"
> +#include "messages.h"
> +#include "transaction.h"
> +#include "xattr.h"
> +
> +static int btrfs_fscrypt_get_context(struct inode *inode, void *ctx, size_t len)
> +{
> +	struct btrfs_key key = {
> +		.objectid = btrfs_ino(BTRFS_I(inode)),
> +		.type = BTRFS_FSCRYPT_INODE_CTX_KEY,
> +		.offset = 0,
> +	};
> +	struct btrfs_path *path;
> +	struct extent_buffer *leaf;
> +	unsigned long ptr;
> +	int ret;
> +
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	ret = btrfs_search_slot(NULL, BTRFS_I(inode)->root, &key, path, 0, 0);
> +	if (ret) {
> +		len = -ENOENT;
> +		goto out;
> +	}
> +
> +	leaf = path->nodes[0];
> +	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
> +	/* fscrypt provides max context length, but it could be less */
> +	len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));
> +	read_extent_buffer(leaf, ctx, ptr, len);
> +
> +out:
> +	btrfs_free_path(path);
> +	return len;
> +}
> +
> +static int btrfs_fscrypt_set_context(struct inode *inode, const void *ctx,
> +				     size_t len, void *fs_data)
> +{
> +	struct btrfs_trans_handle *trans = fs_data;
> +	struct btrfs_key key = {
> +		.objectid = btrfs_ino(BTRFS_I(inode)),
> +		.type = BTRFS_FSCRYPT_INODE_CTX_KEY,
> +		.offset = 0,
> +	};
> +	struct btrfs_path *path = NULL;
> +	struct extent_buffer *leaf;
> +	unsigned long ptr;
> +	int ret;
> +
> +	if (!trans)
> +		trans = btrfs_start_transaction(BTRFS_I(inode)->root, 2);
> +	if (IS_ERR(trans))
> +		return PTR_ERR(trans);
> +
> +	path = btrfs_alloc_path();
> +	if (!path) {
> +		ret = -ENOMEM;
> +		goto out_err;
> +	}
> +
> +	ret = btrfs_search_slot(trans, BTRFS_I(inode)->root, &key, path, 0, 1);
> +	if (ret < 0)
> +		goto out_err;
> +
> +	if (ret > 0) {
> +		btrfs_release_path(path);
> +		ret = btrfs_insert_empty_item(trans, BTRFS_I(inode)->root, path, &key, len);
> +		if (ret)
> +			goto out_err;
> +	}
> +
> +	leaf = path->nodes[0];
> +	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
> +
> +	len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));
> +	write_extent_buffer(leaf, ctx, ptr, len);
> +	btrfs_mark_buffer_dirty(trans, leaf);
> +	btrfs_release_path(path);
> +
> +	if (fs_data)
> +		return ret;

Does this code leak the path when fs_data is non-NULL?

In btrfs_fscrypt_set_context(), a path is allocated via btrfs_alloc_path()
but when fs_data is provided (during inode creation with a transaction
handle), the function returns here without calling btrfs_free_path(path).

The btrfs_release_path() call above only releases internal references to
extent buffers and locks but does not free the path structure itself.

This leak occurs on every encrypted inode creation. The fix would be to add
btrfs_free_path(path) before the return.

> +
> +	BTRFS_I(inode)->flags |= BTRFS_INODE_ENCRYPT;
> +	btrfs_sync_inode_flags_to_i_flags(BTRFS_I(inode));
> +	inode_inc_iversion(inode);
> +	inode_set_ctime_current(inode);
> +	ret = btrfs_update_inode(trans, BTRFS_I(inode));
> +	if (ret)
> +		goto out_abort;
> +	btrfs_free_path(path);
> +	btrfs_end_transaction(trans);
> +	return 0;
> +out_abort:
> +	btrfs_abort_transaction(trans, ret);
> +out_err:
> +	if (!fs_data)
> +		btrfs_end_transaction(trans);
> +	btrfs_free_path(path);
> +	return ret;
> +}

[ ... ]


