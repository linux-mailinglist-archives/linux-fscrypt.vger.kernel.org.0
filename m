Return-Path: <linux-fscrypt+bounces-1130-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sJ7mOFSpiGlEtwQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1130-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:18:44 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC4D1091D8
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:18:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E6F1B301FCA6
	for <lists+linux-fscrypt@lfdr.de>; Sun,  8 Feb 2026 15:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF70535FF61;
	Sun,  8 Feb 2026 15:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="AYDiXkLm"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9DF35FF55;
	Sun,  8 Feb 2026 15:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770563879; cv=none; b=FPWw92OUKAbn2aDk8wBaoM0dEXGncSAyBmEA8itg96VnRpF6+ygBDAjPyBb/k2CeHh7tjMW0sJdWTeOrq2RfjkptaP/xQaM53LhFanOFZGomdJkdh1TG9F82lQojBp9dH90hC3+mojqLTTcHljDEpLo2/nRRRcqgMugB9gTjiKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770563879; c=relaxed/simple;
	bh=Woggvg9xOyRwc61ZepnkXZ8hfYSUASzQmY/LkUm+YX8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j0iz7TuD2jCZ0xrjSbbMq7fZ9T1vUZuzhQ7LDwbZnaJL+44G/sf3sZfofel2J+vE3bQse2jC33xucSowSAzAbL7+86DKEJQz0EFXFsHYQQ/CRbf2iEHISDFWt2Av2WJN8OHoaJ7ApzANuPSpyo2RlRLjy5YCA5+OeSQMWwvOOtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=AYDiXkLm; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 617NpWw3560368;
	Sun, 8 Feb 2026 07:17:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=gs8SCkQFtO04Xxz9un5q0dFqqtwOiPR2PPUojrONIhQ=; b=AYDiXkLmquEt
	f4/AcvUpp+yh8tCFqpIe/Eo1HeFDFsWXNjxWXdqS7bzV5Vqvambv8cWxZunINYSN
	CBWsn3/BPgAGiJDL4LhLdUu/YJnxYWLn5jygnEZR0P1No2cHY45DLSuxGFre4h7x
	7VQTv8TW+a3CNcGS5QJLdNQpCzJVway2W5T6TqrpLCKzBOy7YD4tspqfYedR26Xb
	50HEnqdDdoF6hfst2CBQSqGVZ3YxuCZcb2P/qYCd4icGNqUCJlzBwueRNpTPUaGw
	3xfnPTlitUio4sLg7TuLRqmtTJY1PvCCQ5OPljIrz8++BRlL71i/MPf4gnb2yrI0
	DSfkQnksqA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c65jjywt1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 08 Feb 2026 07:17:43 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Sun, 8 Feb 2026 15:17:42 +0000
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
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 24/43] btrfs: add extent encryption context tree item type
Date: Sun, 8 Feb 2026 07:16:31 -0800
Message-ID: <20260208151728.3212554-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206182336.1397715-25-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-25-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: O63-ypjWyBcIT62hu4bTcOKh2Mj56LUm
X-Proofpoint-GUID: O63-ypjWyBcIT62hu4bTcOKh2Mj56LUm
X-Authority-Analysis: v=2.4 cv=HM/O14tv c=1 sm=1 tr=0 ts=6988a917 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8 a=iox4zFpeAAAA:8 a=maIFttP_AAAA:8
 a=QuLTukprbzUGNeQCIAoA:9 a=WzC6qhA0u3u7Ye7llzcV:22 a=qR24C9TJY6iBuJVj_x8Y:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDEzMSBTYWx0ZWRfX2xEGZmLiVbBf
 hegRw0j1OHMRoWmYtFwQjGYvKBrh0y9dh5jLeQb98XmtwkbxIRUhQeMjj28qj6d24Mm2Y/1zOFh
 GPBG7rc3duXrQFlmdBhiZkLyGLIvsOFCXOQj00/sWcvBIYQYQavyjGPb4V9z/JgmDmCO/IbdFOC
 tM3ymB6moOBq+rxX/ZVsQcSvmneYPpD6cS2jUQxyQcmqHtiLam8z+XhxcrFFY9q0Gx5KmWU4ajm
 B9Ourt8xe8AVfInmPZb5pWHyEsoOU931wlNZivK+5Y1KqK4g7eMB3b2RMBWaywraHAp79QQNQDM
 6hJc7fBsCXe8+7dLgQnMGc/Ts1gou3xGTvg82RJ3M5A9IvVD6aQsjkl3xSPxtsXmgRM2L3ZIod6
 Ijo/XmAKR5FueMuHbPbEPyC7Soq6arfaS5O+qwr/N3JSdR0/yjESE/5swGpcNfHvYgUVWGEAtqY
 3cywRGXPo/VIPjXa1Uw==
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1130-lists,linux-fscrypt=lfdr.de];
	DKIM_TRACE(0.00)[meta.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clm@meta.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.com:email,meta.com:mid,meta.com:dkim]
X-Rspamd-Queue-Id: 6EC4D1091D8
X-Rspamd-Action: no action

Daniel Vacek <neelx@suse.com> wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> The fscrypt encryption context will be stored as a new tree item type.
> This gives us flexibility to include different things in the future.
> 
> Also update the tree-checker to validate the new item type.

Hi everyone,

I'm running the btrfs for-next branch, along with the encryption patch set
through my AI review prompts:

https://github.com/masoncl/review-prompts

I'm working on some btrfs specific instructions, but hopefully these reviews
are already useful.  I've kept the headers to make it easier to double check
that I'm actually replying to the right email, but please let me know if any
parts of this are incorrect:

commit 203bfb91a4db9c826fa7f72034c13a1810a1b605
Author: Josef Bacik <josef@toxicpanda.com>

btrfs: add extent encryption context tree item type

The fscrypt encryption context will be stored as a new tree item type.
This gives us flexibility to include different things in the future.
Also update the tree-checker to validate the new item type.

> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 3c0db279f592e..639462164d089 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c

[ ... ]

> @@ -496,6 +503,60 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
>  		args->extent_inserted = true;
>  	}
>
> +	if (first_ctx <= last_ctx) {
> +		int slot, nritems;
> +
> +		btrfs_release_path(path);
> +
> +		key.objectid = ino;
> +		key.type = BTRFS_FSCRYPT_CTX_KEY;
> +		key.offset = first_ctx;
> +
> +		ret = btrfs_search_slot(trans, root, &key, path, modify_tree, !!modify_tree);
> +		if (ret < 0)
> +			goto out_ctx;

[ ... ]

> +out_ctx:
> +		if (args->path && args->extent_inserted) {
> +			btrfs_release_path(path);
> +
> +			key.objectid = ino;
> +			key.type = BTRFS_EXTENT_DATA_KEY;
> +			key.offset = args->start;
> +			ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
> +		}
> +	}
> +

Can btrfs_search_slot() at line 556 overwrite an error that occurred
earlier in the out_ctx path?

If btrfs_search_slot() at line 515 fails and execution jumps to out_ctx,
but args->path and args->extent_inserted are both true, the second
btrfs_search_slot() call will overwrite the original error stored in ret.

If this second search succeeds (returns 0 or >0), the function returns
success to the caller despite the fscrypt context cleanup having failed.
This could lead to inconsistent filesystem state where extent data was
inserted but the corresponding fscrypt context items were not properly
cleaned up.

> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 9675dbcd78a3b..776901f297fea 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c

[ ... ]

> +static int check_fscrypt_context(struct extent_buffer *leaf,
> +				 struct btrfs_key *key, int slot,
> +				 struct btrfs_key *prev_key)
> +{
> +	u32 sectorsize = leaf->fs_info->sectorsize;
> +	u32 item_size = btrfs_item_size(leaf, slot);
> +
> +	if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
> +		file_extent_err(leaf, slot,
> +"unaligned file_offset for encryption context, have %llu should be aligned to %u",
> +			key->offset, sectorsize);
> +		return -EUCLEAN;
> +	}
> +
> +	/*
> +	 * Previous key must have the same key->objectid (ino).
> +	 * It can be XATTR_ITEM, INODE_ITEM or just another EXTENT_DATA.
> +	 * But if objectids mismatch, it means we have a missing
> +	 * INODE_ITEM.
> +	 */

This isn't a bug, but the comment says "It can be XATTR_ITEM, INODE_ITEM
or just another EXTENT_DATA" - can EXTENT_DATA actually be the previous
key type?

For BTRFS_FSCRYPT_CTX_KEY (type=42), EXTENT_DATA (type=108) cannot be a
previous key because keys are sorted by (objectid, type, offset) and
108 > 42.

The correct previous key types would be: XATTR_ITEM, INODE_ITEM,
FSCRYPT_INODE_CTX_KEY, or another FSCRYPT_CTX_KEY.

> @@ -214,6 +248,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
>  	u32 item_size = btrfs_item_size(leaf, slot);
>  	u64 extent_end;
>  	u8 policy;
> +	u8 fe_type;
>
>  	if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
>  		file_extent_err(leaf, slot,

[ ... ]

> @@ -298,6 +333,19 @@ static int check_extent_data_item(struct extent_buffer *leaf,
>  		return 0;
>  	}
>
> +	if (policy == BTRFS_ENCRYPTION_FSCRYPT) {
> +		/*
> +		 * Only regular and prealloc extents should have an encryption
> +		 * context.
> +		 */
> +		if (unlikely(fe_type != BTRFS_FILE_EXTENT_REG &&
> +			     fe_type != BTRFS_FILE_EXTENT_PREALLOC)) {
> +			file_extent_err(leaf, slot,
> +		"invalid type for encrypted file extent, have %u", fe_type);
> +			return -EUCLEAN;
> +		}
> +	}

Can this validation check detect encrypted inline extents? Looking at
the function flow, inline extents (BTRFS_FILE_EXTENT_INLINE) are handled
at lines 310-333 and return before reaching this check.

If a corrupted filesystem has an encrypted inline extent, it would pass
tree-checker validation. Should the encryption check be moved to also
cover the inline extent path, or should inline extents explicitly reject
BTRFS_ENCRYPTION_FSCRYPT?


