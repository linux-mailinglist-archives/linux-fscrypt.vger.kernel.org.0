Return-Path: <linux-fscrypt+bounces-1136-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8OHUOr6viGlTuQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1136-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:46:06 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 51F361094F3
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:46:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E100D300FEC3
	for <lists+linux-fscrypt@lfdr.de>; Sun,  8 Feb 2026 15:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9490B3570D9;
	Sun,  8 Feb 2026 15:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="PQC4UqYq"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A2B1DC997;
	Sun,  8 Feb 2026 15:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770565564; cv=none; b=nZAVolYjKIkPzdNaIcqXYW0gTdvBlF5iLNSRrj/+ppwAbRdYaE5OIumj2TBUPRlTI9X1unDn8Hux6LLRvXQf7kI64+0cDtSlqzyRUTelhIgE0E3P3j791HvNlfY1MmNH6hlvzK8a54yVx9HmDUAwpOd66nerKw2259t8ExrK298=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770565564; c=relaxed/simple;
	bh=BVZlCooIP+3CoJVrJRcq/JMDT9aA2HKBaCJaSp9wDV8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B9pyKTMljLYN+0drBi5ahEL/Xx6+16GuxWQhhckqpZhGewKJ2Bs13fxOmLOczGEdLLC/C3Py9ez+Sy7F2bHHbkvm85v+HherHDrnqEY7bMWf8rr2FdBwi//3f4paBLvTZnuLe2seq0Aep/Otd23PgprJyxECwdV+NIecWuBCcx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=PQC4UqYq; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 618BHp632454622;
	Sun, 8 Feb 2026 07:45:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=dCMDtr1XTQrFphWhlBPtBA1vakQMmpwVIyr6tPT3/RY=; b=PQC4UqYqp2aL
	/ya7WE3BCqBS8GdGEn9ByEsbiiF1etssTMq954ZT8I5wGVH0UWy2BKrvRw3CpecQ
	4Gjp4ayomzcvodpCq2APtXMtQtPhUcCJgE7kn/uLLlZm+B2t5/SiBoWoUoVIlKu1
	+AfwQI4iLhko//XpBn0FmSqSYo98jx4ce6kEGNxSLvzNTfbqQAGE9wo4rsZ0VGhW
	8U7SzO75fyEq+T8iRPNqLz9Vid6+vOFmfFX9XovXsaAjQITZquHyfj4NT+8tZgc9
	IAe2r/2zf3ZHd0Gs6tCgjvjF4iPeJ46M6lBt9RxZsyKH4g22Q7boM8OI9wVXNadG
	GJfU/eYyOw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c63c9gqj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 08 Feb 2026 07:45:46 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Sun, 8 Feb 2026 15:45:45 +0000
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
Subject: Re: [PATCH v6 10/43] btrfs: start using fscrypt hooks
Date: Sun, 8 Feb 2026 07:44:45 -0800
Message-ID: <20260208154525.3580889-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206182336.1397715-11-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-11-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: R3GAdtBSOM7vZ1mpbg7--Ows1iWKTQdC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDEzNiBTYWx0ZWRfXw0dyW29DHLBQ
 ZOIue4bGXwoy73aZN/Po3djoDkJXsmy/G5Srzot6iB5gXsRZ3TpLlyb+0JEd0Kxixsy3EGEHOY8
 QNwxDfSBkD4tMGdS8Y5NwGvGcvDrwuKRoWiiN8z+2SW5Ek2doP0p++KeTkLoyfFUPDRWl3/nXeX
 lsdOa99bCxb4H9qp8vf05YgfY3wgH3Kvf+kLImjpu8OHedwmc3nbY/oXZcKkv7ZEBvDbHJXtx/a
 +9LpEzCV6KRhusPSQv/soY0BB3KJNCnKvRAhMKUnhbo3KAoBPdIGl+T0w5/5NWCzSPbzJRvn0r4
 b3iMdiCIBIbMbbXd6WKwaZFwfthqlZ3dQxqFlWaauyfpuCaaZANNlXFZ8CNcF1APBeuA59GUYmo
 D18e3mwy3d1PaLBhVn5f0vSMwD4lyYqGU1aSMfHz8EuxbE9vPfLHQB2Qifj8firqbowNEA6Y/jt
 LhCYNsFiYW0bAl4xrVA==
X-Proofpoint-GUID: R3GAdtBSOM7vZ1mpbg7--Ows1iWKTQdC
X-Authority-Analysis: v=2.4 cv=H5fWAuYi c=1 sm=1 tr=0 ts=6988afaa cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8 a=iox4zFpeAAAA:8 a=-uoBkjAQAAAA:8
 a=OMOj4mSnXPpJsoStnEoA:9 a=WzC6qhA0u3u7Ye7llzcV:22 a=y0wLjPFBLyexm0soFTcm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_04,2026-02-05_03,2025-10-01_01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1136-lists,linux-fscrypt=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clm@meta.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[meta.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 51F361094F3
X-Rspamd-Action: no action

Daniel Vacek <neelx@suse.com> wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> In order to appropriately encrypt, create, open, rename, and various
> symlink operations must call fscrypt hooks. These determine whether the
> inode should be encrypted and do other preparatory actions. The
> superblock must have fscrypt operations registered, so implement the
> minimal set also, and introduce the new fscrypt.[ch] files to hold the
> fscrypt-specific functionality.

Hi everyone,

I'm running the btrfs for-next branch, along with the encryption patch set
through my AI review prompts:

https://github.com/masoncl/review-prompts

I'm working on some btrfs specific instructions, but hopefully these reviews
are already useful.  I've kept the headers to make it easier to double check
that I'm actually replying to the right email, but please let me know if any
parts of this are incorrect:

commit 4d7d769810b1d47ec75a6efa0f691c43d9969b54
Author: Omar Sandoval <osandov@osandov.com>

btrfs: start using fscrypt hooks

This commit adds fscrypt support to btrfs by implementing fscrypt hooks
in various inode operations including create, open, rename, and symlink
operations.

> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b6c763a17406b..9d90e2e946fc4 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c

[ ... ]

> @@ -6506,6 +6510,12 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
>  		return ret;
>  	}
>
> +	ret = fscrypt_prepare_new_inode(dir, inode, &args->encrypt);
> +	if (ret) {
> +		fscrypt_free_filename(&args->fname);
> +		return ret;
> +	}
> +

When fscrypt_prepare_new_inode() fails, are the ACLs leaked?

Looking earlier in the function, posix_acl_create() allocates args->acl
and args->default_acl. When fscrypt_prepare_new_inode() fails, the
error path frees the filename but doesn't release these ACLs.

Callers like btrfs_symlink() skip btrfs_new_inode_args_destroy() on
error, so the ACLs would never be released. Should this add
posix_acl_release() calls before returning?

[ ... ]

> @@ -8994,20 +9015,28 @@ static int btrfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
>  	};
>  	unsigned int trans_num_items;
>  	int ret;
> -	int name_len;
>  	int datasize;
>  	unsigned long ptr;
>  	struct btrfs_file_extent_item *ei;
>  	struct extent_buffer *leaf;
> +	struct fscrypt_str disk_link;
> +	size_t max_len;
> +	u32 name_len = strlen(symname);
> +
> +	/*
> +	 * BTRFS_MAX_INLINE_DATA_SIZE() isn't actually telling the truth, we actually
> +	 * limit inline data extents to min(BTRFS_MAX_INLINE_DATA_SIZE(), sectorsize),
> +	 * so adjust max_len given this wonderful bit of inconsistency.
> +	 */
> +	max_len = min_t(size_t, BTRFS_MAX_INLINE_DATA_SIZE(fs_info), fs_info->sectorsize);
>
> -	name_len = strlen(symname);
>  	/*
> -	 * Symlinks utilize uncompressed inline extent data, which should not
> -	 * reach block size.
> +	 * fscrypt sets disk_link.len to be len + 1, including a NUL terminator,
> +	 * but we don't store that '\0' character.
>  	 */
> -	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info) ||
> -	    name_len >= fs_info->sectorsize)
> -		return -ENAMETOOLONG;
> +	ret = fscrypt_prepare_symlink(dir, symname, name_len, max_len + 1, &disk_link);
> +	if (ret)
> +		return ret;
>
>  	inode = new_inode(dir->i_sb);
>  	if (!inode)

[ ... ]

> @@ -9044,10 +9073,22 @@ static int btrfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
>  		inode = NULL;
>  		goto out;
>  	}
> +
> +	if (IS_ENCRYPTED(inode)) {
> +		ret = fscrypt_encrypt_symlink(inode, symname, name_len, &disk_link);
> +		if (ret) {
> +			btrfs_abort_transaction(trans, ret);
> +			btrfs_free_path(path);
> +			discard_new_inode(inode);
> +			inode = NULL;
> +			goto out;
> +		}
> +	}
> +
>  	key.objectid = btrfs_ino(BTRFS_I(inode));
>  	key.type = BTRFS_EXTENT_DATA_KEY;
>  	key.offset = 0;
> -	datasize = btrfs_file_extent_calc_inline_size(name_len);
> +	datasize = btrfs_file_extent_calc_inline_size(disk_link.len - 1);
>  	ret = btrfs_insert_empty_item(trans, root, path, &key, datasize);
>  	if (unlikely(ret)) {
>  		btrfs_abort_transaction(trans, ret);

[ ... ]

> @@ -9084,6 +9125,29 @@ static int btrfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
>  	return ret;
>  }

Does this code leak disk_link.name when creating encrypted symlinks?

According to fscrypt.h, when fscrypt_encrypt_symlink() is called,
'one will be kmalloc()'ed and the filesystem will be responsible
for freeing it'. However, btrfs_symlink() never frees disk_link.name
in any exit path, whether success or failure.

Looking at ext4/namei.c:3443-3444, it correctly handles this:

    if (disk_link.name != (unsigned char *)symname)
        kfree(disk_link.name);

Should similar cleanup be added here?


