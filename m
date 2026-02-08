Return-Path: <linux-fscrypt+bounces-1133-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aBXgEAGsiGk6uAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1133-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:30:09 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B011B1092A8
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:30:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 832B63008281
	for <lists+linux-fscrypt@lfdr.de>; Sun,  8 Feb 2026 15:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE5903624C6;
	Sun,  8 Feb 2026 15:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="DtI1Uvx8"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A4C3624B1;
	Sun,  8 Feb 2026 15:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770564606; cv=none; b=qdfzZHzz6Vn9DU9tXSBtgK4fsKB6wmgo9tllX6Wtht62pQqV2qofSNPcjrm0BhHQOrBogclN4QVtGZa9vC2IVl3bCXpIEXd60L14d9qMCye21a/VGBMh1+/bU9fLvhzIrvWwjPcDAsGcRp4RFi0NqNyMMKfoU5QHJQrT7WPRWU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770564606; c=relaxed/simple;
	bh=OPLxtwo1PZ0iyyHfkV3n7IX10Xip5dGFff/OtmqxEaA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jDOQbVEwQeOP30go/wSG1esUkW+iXqeW3Z6pp76CUo9qxviEXdCwVFWsj9KxPLexxU4aetsp2hOTfIxAfTDyLeS4fpDagSfqZj2nld9CixZC8fjwWYzPMJEJjOVs4zknqy3r/YzeVITQPwlQO9xVi5KHVeRHvxSIbtZCMlyGkSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=DtI1Uvx8; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6185SuIa1356952;
	Sun, 8 Feb 2026 07:29:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=Ho3R5V988yj8OusYwpmZeU3E/EJM4remiDxPBuhHMvc=; b=DtI1Uvx8/2j5
	fEZU/N04wqtLoAvpgoq2+i7PecRSsTWN/6ydPW3YkhU+TuUcwJSJ9mmymDZangPA
	Ch1rNPvSCPFSa9bM7TBeq5SFWeMOhz/jq9ZlMROePKzWoKJlB1oT2XKkcbzGmoUR
	H45SRB/rcIrWX1pxA3A93XkoxCI8aTMVK7lJILTlPvugX+pnz8LGLaHX+jtjcNIt
	ElisZ3Bc+WdKe66++JWIY8OuuZF6MwS8jp/TT4dPRxwYCbS7duE95fiZYbyVdQfd
	fn+4ksDCwyLqXnCbYCMRDM87w5UKlXOFID37cV/Vy2LRWGWebM8YqPRIPmRxXPL5
	DyFauxPxCQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c62a28xpa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 08 Feb 2026 07:29:49 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Sun, 8 Feb 2026 15:29:47 +0000
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
        Sweet Tea Dorminy
	<sweettea-kernel@dorminy.me>
Subject: Re: [PATCH v6 14/43] btrfs: handle nokey names
Date: Sun, 8 Feb 2026 07:28:21 -0800
Message-ID: <20260208152914.3379032-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206182336.1397715-15-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-15-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDEzNCBTYWx0ZWRfXxZeXsdGFqydx
 JveEd8hSpZqizE+NJVPfFszxi9gp6NNm0szve3PtnkKJ0glY9ENFc2L465sjprr38XaJH/0OR4f
 vJnRFQ7nMB6PoNwikwcEJZqQmVXDioLdeyh7wyZA8wtugSekAtEP0TnSJYm1f92Zy+n/WNxbFdN
 7tdLWdoXk1ez6r0OJ3dEBRSiLZwSF/h8KLEmVkCrwlzHvXeqNkZbCEbGP/YRTvoAoKS3B5ZM41Y
 jt75sPu6tE3sR89BGZHi7VHEff9mId3/1hxs/BeC4E5OLCInMnejdYeAyKRCq+b/n4tXVQ0+v2k
 1v/HexqPaUuWLA0p5Mxh13vAqogsGDZcSZhQI1HfpCwVZUioZ8NzNpo2qAgBb/6x7kUg18oLPwD
 JtEgguufnVwna3RDkcaB5kViQXABV0TPVOi9dJi07NvC6UelT2eKjELEn8Hf+zAh6rW2jIkrryV
 mLkac5SLeiL4svKfghw==
X-Proofpoint-ORIG-GUID: TNdPY530011vzYe7DSy_rzJop3kslKCo
X-Authority-Analysis: v=2.4 cv=I9Bohdgg c=1 sm=1 tr=0 ts=6988abed cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8 a=iox4zFpeAAAA:8
 a=A3akw4-Iil3SQCV9tNoA:9 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-GUID: TNdPY530011vzYe7DSy_rzJop3kslKCo
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1133-lists,linux-fscrypt=lfdr.de];
	DKIM_TRACE(0.00)[meta.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clm@meta.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.com:email,meta.com:mid,meta.com:dkim]
X-Rspamd-Queue-Id: B011B1092A8
X-Rspamd-Action: no action

Daniel Vacek <neelx@suse.com> wrote:
> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> 
> For encrypted or unencrypted names, we calculate the offset for the dir
> item by hashing the name for the dir item. However, this doesn't work
> for a long nokey name, where we do not have the complete ciphertext.
> Instead, fscrypt stores the filesystem-provided hash in the nokey name,
> and we can extract it from the fscrypt_name structure in such a case.
> 
> Additionally, for nokey names, if we find the nokey name on disk we can
> update the fscrypt_name with the disk name, so add that to searching for
> diritems.

Hi everyone,

I'm running the btrfs for-next branch, along with the encryption patch set
through my AI review prompts:

https://github.com/masoncl/review-prompts

I'm working on some btrfs specific instructions, but hopefully these reviews
are already useful.  I've kept the headers to make it easier to double check
that I'm actually replying to the right email, but please let me know if any
parts of this are incorrect:

commit fabad1c3ea82184fba8e78ce1da1b2fbe8c34fae
Author: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

btrfs: handle nokey names

This commit adds support for handling nokey names in btrfs, enabling
proper hash calculation and disk name extraction for long encrypted
filenames when the encryption key is unavailable.

> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index 6e10dd4a4e9e1..75c213bd826e9 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -228,6 +228,27 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
>  	return di;
>  }
>
> +/*
> + * If appropriate, populate the disk name for a fscrypt_name looked up without
> + * a key.
> + *
> + * @path:	The path to the extent buffer in which the name was found.
> + * @di:		The dir item corresponding.
> + * @fname:	The fscrypt_name to perhaps populate.
> + *
> + * Returns: 0 if the name is already populated or the dir item doesn't exist
> + * or the name was successfully populated, else an error code.
> + */
> +static int ensure_disk_name_from_dir_item(struct btrfs_path *path,
> +					  struct btrfs_dir_item *di,
> +					  struct fscrypt_name *name)
> +{
> +	if (name->disk_name.name || !di)
> +		return 0;
> +
> +	return btrfs_fscrypt_get_disk_name(path->nodes[0], di, &name->disk_name);
> +}
> +

[ ... ]

> @@ -263,6 +287,8 @@ struct btrfs_dir_item *btrfs_lookup_dir_item_fname(struct btrfs_trans_handle *tr
>
>  	if (ret == -ENOENT || (di && IS_ERR(di) && PTR_ERR(di) == -ENOENT))
>  		return NULL;
> +	if (ret == 0)
> +		ret = ensure_disk_name_from_dir_item(path, di, name);
>  	if (ret < 0)
>  		di = ERR_PTR(ret);
>

Does ensure_disk_name_from_dir_item() leak memory when it allocates a
disk name? Looking at the call chain:

btrfs_unlink_subvol() at inode.c:4583 calls btrfs_lookup_dir_item_fname(),
which calls ensure_disk_name_from_dir_item(), which calls
btrfs_fscrypt_get_disk_name() at fscrypt.c:34, allocating memory via
kmalloc() and storing it in name->disk_name.name.

However, btrfs_unlink_subvol() cleans up with fscrypt_free_filename() at
include/linux/fscrypt.h:503, which only frees name->crypto_buf.name, not
name->disk_name.name.

The same issue appears in btrfs_search_dir_index_item() at line 405, which
also calls ensure_disk_name_from_dir_item().

For nokey encrypted filenames, wouldn't this leak memory on every
successful lookup?


