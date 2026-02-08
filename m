Return-Path: <linux-fscrypt+bounces-1134-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gl2qGJWtiGkSuQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1134-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:36:53 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D0E1092CF
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:36:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 21981301177D
	for <lists+linux-fscrypt@lfdr.de>; Sun,  8 Feb 2026 15:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A757364E86;
	Sun,  8 Feb 2026 15:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="HCV++WyY"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E856A364E80;
	Sun,  8 Feb 2026 15:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770565007; cv=none; b=mTdpXfwHuJkTqbm6VEzwK/EGEeLF5L9fq85YrZqj0tw9/VN4DcF4Rqex9CIhoFgPPHpUx/QAWPM23NGWnBmhwvV+2qQ5XRkgdGpY1Q5hAUGbmOwxoTBlUeioYoyew6bJkLsXb7p+4XwV7yw4Y3zc8EdopkX7oORQ6GwSMdrcGlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770565007; c=relaxed/simple;
	bh=LDqL+8D6+WrpB6GaHwKZ5Lnt1v1cCw3UANj7uFkTSO8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IvFev17VEQfHmqYTzs8gj7ozWQOeCyvTa4xutfmdp4L2XIUjbzJxU/WrboF0nnS7vSmdDFf/tlYyUsClGWC0sPXVe4sPohKbXE2vR103yJfQ0tIJzLzBi8w/FyAcVywT5Ra65KFxew1o7llPHBRaW2UVIN7JbaC3WCDd79M9rV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=HCV++WyY; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 618F4EhX218612;
	Sun, 8 Feb 2026 07:36:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=jmri1L2Of4imCELLjdnvlb3gFufkIoCDJP74eMZ6fiI=; b=HCV++WyYRAWj
	MOnZQluHDUTuOF5F7XvV9K4t831aGyQRuBJFhVzB1FyIyx+y8/2wpRUCX2k69ZT3
	GXemFovnLwoXVHg7c+3vR4XikcnhLIM0xf6XAKSgdqhdY0SYx8lGP/+e6fmtLgFi
	aTmS3hNeegFDHjz+OS+DI9+VbnkdWcJPoA1NZXuCk62RmiPJi3EbYxSAOmCRFNWr
	wiLZ6s0enhi3PkUmzGXt6x5FMSRbikk3THPOIFBca2iFQMBQMN+7jWtNDCGjE6S+
	l0+dODMwjyoODuCkv5VBL8ZGz8Bf0eIYrf7T1I6CwjgcpaE1oR5Xz7bIO1IoZ6BL
	hBj0jo7WlQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4c61rqs2th-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 08 Feb 2026 07:36:38 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Sun, 8 Feb 2026 15:36:21 +0000
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
Subject: Re: [PATCH v6 13/43] btrfs: adapt readdir for encrypted and nokey names
Date: Sun, 8 Feb 2026 07:35:32 -0800
Message-ID: <20260208153607.3466929-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206182336.1397715-14-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-14-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDEzNCBTYWx0ZWRfX+zyCn1AE/gMu
 AjOi1WxCu5MyvQBPpN9rkILATbKl48vP+mNnNKJ7iuYAyd6ciPmmj8W8XAZOh9YF3M+iHJ5UbcY
 JpuMFwhRRcCKVSELt+zcE5WjYC5/nMSSVXRLJsuVV0l6mldRzfm5l+OB7g3CydwR2axztQA4gmK
 Pmq+gYhK8UhQZveD6Lb5B2O4GP82EQidWzD8w3WOkT6szlT6xw6RcDOlY9Fjte1mfI52KOIZfW+
 HjSdNYDU2NpjBGF8tZnSiOfbppLk8svDk1oTbsLLmdbiqfkb+a1Jei2hMYsyWQdV0Zh3ItPA65P
 OpL/q+ZUdelbBZn6JIZ8PVAeGXAVWwuvHuDQDawT9kKgVMzrGOkMB0kq+N+wtefGlp+70hnFmak
 Q5qd1422HKfvAHDz0rSqcns1oaGV3Vc28qpi7sv5CDRmlNKqHGG1HYw0+PPLF5ARFNYxCeu3DRm
 +wLyqFVAfF6xrtj28wQ==
X-Proofpoint-ORIG-GUID: Aynm4PfEfYYx1xWcA-Dsx7_B25u3gRoJ
X-Proofpoint-GUID: Aynm4PfEfYYx1xWcA-Dsx7_B25u3gRoJ
X-Authority-Analysis: v=2.4 cv=c+umgB9l c=1 sm=1 tr=0 ts=6988ad86 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8 a=iox4zFpeAAAA:8 a=-uoBkjAQAAAA:8
 a=NwBGFpfTi0Ikja0T_L4A:9 a=WzC6qhA0u3u7Ye7llzcV:22 a=y0wLjPFBLyexm0soFTcm:22
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1134-lists,linux-fscrypt=lfdr.de];
	DKIM_TRACE(0.00)[meta.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clm@meta.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:mid,meta.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email]
X-Rspamd-Queue-Id: 95D0E1092CF
X-Rspamd-Action: no action

Daniel Vacek <neelx@suse.com> wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> Deleting an encrypted file must always be permitted, even if the user
> does not have the appropriate key. Therefore, for listing an encrypted
> directory, so-called 'nokey' names are provided, and these nokey names
> must be sufficient to look up and delete the appropriate encrypted
> files. See 'struct fscrypt_nokey_name' for more information on the
> format of these names.

Hi everyone,

I'm running the btrfs for-next branch, along with the encryption patch set
through my AI review prompts:

https://github.com/masoncl/review-prompts

I'm working on some btrfs specific instructions, but hopefully these reviews
are already useful.  I've kept the headers to make it easier to double check
that I'm actually replying to the right email, but please let me know if any
parts of this are incorrect:

commit e264482bd61ca8096981d81cc5e7c839284ac969
Author: Omar Sandoval <osandov@osandov.com>

btrfs: adapt readdir for encrypted and nokey names

This commit adapts the btrfs readdir implementation to handle encrypted
filenames and nokey names, enabling directory listing and deletion of
encrypted files even without the encryption key.

> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 1739a0b29c49d..c19213fab3dda 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c

[ ... ]

> @@ -1820,7 +1823,25 @@ bool btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
>  		d_type = fs_ftype_to_dtype(btrfs_dir_flags_to_ftype(di->type));
>  		btrfs_disk_key_to_cpu(&location, &di->location);
>
> -		over = !dir_emit(ctx, name, name_len, location.objectid, d_type);
> +		if (di->type & BTRFS_FT_ENCRYPTED) {
> +			int ret;
> +			struct fscrypt_str iname = FSTR_INIT(name, name_len);
> +
> +			fstr->len = fstr_len;
> +			/*
> +			 * The hash is only used when the encryption key is not
> +			 * available. But if we have delayed insertions, then we
> +			 * must have the encryption key available or we wouldn't
> +			 * have been able to create entries in the directory.
> +			 * So, we don't calculate the hash.
> +			 */
> +			ret = fscrypt_fname_disk_to_usr(inode, 0, 0, &iname, fstr);
> +			if (ret)
> +				return ret;
> +			over = !dir_emit(ctx, fstr->name, fstr->len, location.objectid, d_type);
> +		} else {
> +			over = !dir_emit(ctx, name, name_len, location.objectid, d_type);
> +		}

Does the return statement at line 1840 cause silent error loss?

The function btrfs_readdir_delayed_dir_index returns bool, but
'return ret;' returns an int error code from fscrypt_fname_disk_to_usr.
Since ret is negative on error (e.g., -EUCLEAN from fname_decrypt
failures), this converts to 'true' in bool context.

The caller btrfs_real_readdir at inode.c:6410 interprets true as "stop
iteration normally":

    if (btrfs_readdir_delayed_dir_index(inode, &fstr, ctx, &ins_list))
        goto nopos;

The nopos label at line 6417 sets ret = 0, which means readdir()
completes successfully with incomplete results when crypto operations
fail on encrypted directory entries.

[ ... ]

> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index 085a83ae9e62f..6e10dd4a4e9e1 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c

[ ... ]

> @@ -227,6 +228,47 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
>  	return di;
>  }
>
> +/*
> + * Lookup for a directory item by fscrypt_name.
> + *
> + * @trans:	The transaction handle to use.
> + * @root:	The root of the target tree.
> + * @path:	Path to use for the search.
> + * @dir:	The inode number (objectid) of the directory.
> + * @name:	The fscrypt_name associated to the directory entry
> + * @mod:	Used to indicate if the tree search is meant for a read only
> + *		lookup or for a deletion lookup, so its value should be 0 or
> + *		-1, respectively.
> + *
> + * Returns: NULL if the dir item does not exists, an error pointer if an error
> + * happened, or a pointer to a dir item if a dir item exists for the given name.
> + */
> +struct btrfs_dir_item *btrfs_lookup_dir_item_fname(struct btrfs_trans_handle *trans,
> +						   struct btrfs_root *root,
> +						   struct btrfs_path *path, u64 dir,
> +						   struct fscrypt_name *name, int mod)
> +{
> +	struct btrfs_key key;
> +	struct btrfs_dir_item *di = NULL;
> +	int ret = 0;
> +
> +	key.objectid = dir;
> +	key.type = BTRFS_DIR_ITEM_KEY;
> +	key.offset = btrfs_name_hash(name->disk_name.name, name->disk_name.len);
> +	/* XXX get the right hash for no-key names */

Can this dereference a NULL pointer for long nokey names?

When btrfs_unlink() calls fscrypt_setup_filename() with lookup=1 for a
nokey encrypted filename, fname->disk_name.name is NULL for long nokey
names (see fscrypt_setup_filename lines 370-375 in fs/crypto/fname.c).

The call chain is: btrfs_unlink -> btrfs_unlink_inode ->
__btrfs_unlink_inode (line 4396) -> btrfs_lookup_dir_item_fname.

This passes NULL to btrfs_name_hash() at line 257, which calls
crc32c(NULL, len), causing a kernel crash. The XXX comment at line 258
acknowledges this is unhandled.

Note: This issue is addressed in a later commit in the patch series
(fabad1c3ea821 'btrfs: handle nokey names').


