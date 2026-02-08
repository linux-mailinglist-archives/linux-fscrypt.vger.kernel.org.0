Return-Path: <linux-fscrypt+bounces-1131-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aOf+GtupiGlEtwQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1131-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:20:59 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C520B109225
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:20:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ED35F30115BD
	for <lists+linux-fscrypt@lfdr.de>; Sun,  8 Feb 2026 15:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE12361672;
	Sun,  8 Feb 2026 15:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Jkkq2+Yu"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCE53587C9;
	Sun,  8 Feb 2026 15:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770564012; cv=none; b=S9tsmeSW44pbxwHCzP0kujuJtKZu+CPjGRLIjmURR3AuidqdeFALkF/ABA8y5T52Xi39d7U+PV5oh6UHf7yVgHcXGuUZf9aDfLRMPMDSDrY1G2bwYMtFZuCn2KawvrC7Og6r0Ia8sCLovYmWqjyk0lJTeOzMfUtsEtsXMUJ90T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770564012; c=relaxed/simple;
	bh=QaPSbE832+68Rw5InmUxYlKwBpYzvFhuYM6VPQ182UA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iwxZkzyO8R7nYorJH7+f1z4hbp1ag/FfiE2ngTLct8W+tLzf/zLxDf6e5tEc0l3IKYi45H1daHaYHX6sXXq7zTWcuxb3K/zZ7Qcddcs4jLOu3rNlZ/Ciedjz2sWNJRXNZ/QwfJ0s4as5y/7tQqgN/XDRM7gqz0fecXKWNg4jasA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Jkkq2+Yu; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 618Ac3Ha3858212;
	Sun, 8 Feb 2026 07:19:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=y3RojGoa24sIFTfx0iDhwH0ATOGw5/3emSljU2kSlQ4=; b=Jkkq2+YuVqa4
	5Cxu6Oddxq7xzrL9lq08W23f6/LCCx3iJyihpQACyTWt92ifKYJyDA5vmMRzaI/1
	jzRbc0RAZEcHj3wpIFJ5/9YUPRFP2+31i4CPu1uCwfD4wu5et3KNu+IxxnQJ0brl
	vf0cVgEzEPNwOPsg9sYYfUguB8h+opHyXv9kHQtkEbpVraR0HcIDWblK5LzYPU+w
	ZlVjSlTRS+oe4/4QK+12iCP/uY7FJTftApb3z6vKcOGs/3+KdNMpshRHRy2tTDGY
	YxZ4obsC98WNiHkpzha6OqxfYafi6tlIBjDVK2XpMA+hRa7WlUAWm77qV48V1pOd
	iR85bj+R1A==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c6rw116ht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 08 Feb 2026 07:19:55 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Sun, 8 Feb 2026 15:19:41 +0000
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
Subject: Re: [PATCH v6 20/43] btrfs: add fscrypt_info and encryption_type to ordered_extent
Date: Sun, 8 Feb 2026 07:18:57 -0800
Message-ID: <20260208151928.3245396-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206182336.1397715-21-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-21-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: NzNrozYJFxlvnm03StbEA4BkQVlp-q8b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDEzMSBTYWx0ZWRfX3fdUxLdwCE/n
 WOMpWlDhylbLPZA1h4UTP6LnXgH0GsmMDJLMLeQM6207UUNud2MrD8X3tre9oScTuUAFm6bFkka
 nWiXepzLD5Px7CrPtrViAR/atbSm+ed+mFWRrYtsdAK88Dbe77nTLn1cvMJHaqrarReyc7oqSY8
 6f8Rig//RORpC8WiCadb/pGMygrjwv2Kvypn4d1wVLHlKqwlK96koj1Jw5mSC6hy+ZGhDaEqS6l
 Os7Yk7uBqnnvGIQVboQVB2SFxhTirKGtcTrgNyXbZPMp4PulwRtIXwr71h6qwvmjgZRhL7kYM4u
 eAZ5t9ycQkO2u7yVxIQBMWp/aowh4vQ3kP5YOT0MUma4la34AhHwTamBCWwtLN6rFeEtdP5jPj9
 tpWiWYqH57f4hXTW8O5FY4Pjc1XUiKBJUxb7DLGds0LReaR7xbfyXoRZl11x4JTF999B9UZk5Xd
 R0DVvxy9MiXLLIAgykA==
X-Authority-Analysis: v=2.4 cv=H67WAuYi c=1 sm=1 tr=0 ts=6988a99b cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8 a=iox4zFpeAAAA:8 a=maIFttP_AAAA:8
 a=UHOwrn5YzTAXftJBTekA:9 a=WzC6qhA0u3u7Ye7llzcV:22 a=qR24C9TJY6iBuJVj_x8Y:22
X-Proofpoint-ORIG-GUID: NzNrozYJFxlvnm03StbEA4BkQVlp-q8b
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
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1131-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:mid,meta.com:dkim,suse.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,toxicpanda.com:email]
X-Rspamd-Queue-Id: C520B109225
X-Rspamd-Action: no action

Daniel Vacek <neelx@suse.com> wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> We're going to need these to update the file extent items once the
> writes are complete.  Add them and add the pieces necessary to assign
> them and free everything.
> 

Hi everyone,

I'm running the btrfs for-next branch, along with the encryption patch set
through my AI review prompts:

https://github.com/masoncl/review-prompts

I'm working on some btrfs specific instructions, but hopefully these reviews
are already useful.  I've kept the headers to make it easier to double check
that I'm actually replying to the right email, but please let me know if any
parts of this are incorrect:

commit 61cd57301840de69a3f6573374d41ad4b4bcf348
Author: Josef Bacik <josef@toxicpanda.com>

btrfs: add fscrypt_info and encryption_type to ordered_extent

This commit adds encryption-related fields (encryption_type and
fscrypt_info) to struct btrfs_ordered_extent to support fscrypt
integration in btrfs.

> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 5df02c707aee6..7a5701937184e 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -192,6 +192,7 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
>  	}
>  	entry->inode = inode;
>  	entry->compress_type = compress_type;
> +	entry->encryption_type = BTRFS_ENCRYPTION_NONE;
>  	entry->truncated_len = (u64)-1;
>  	entry->qgroup_rsv = qgroup_rsv;

This isn't a bug, but the fscrypt_info field isn't explicitly initialized
to NULL here. While kmem_cache_zalloc() at line 175 does zero the memory,
all the other important fields in this function are explicitly initialized
(compress_type, encryption_type, truncated_len, qgroup_rsv, refs). Would
adding an explicit 'entry->fscrypt_info = NULL;' improve consistency?

>  	entry->flags = flags;
> @@ -630,6 +631,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
>  		btrfs_add_delayed_iput(entry->inode);
>  		list_for_each_entry_safe(sum, tmp, &entry->list, list)
>  			kvfree(sum);
> +		fscrypt_put_extent_info(entry->fscrypt_info);
>  		kmem_cache_free(btrfs_ordered_extent_cache, entry);
>  	}
>  }
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index 1e6b0b182b295..ce19198e7f844 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -124,6 +124,9 @@ struct btrfs_ordered_extent {
>  	/* compression algorithm */
>  	int compress_type;
>
> +	/* encryption mode */
> +	u8 encryption_type;
> +

This isn't a bug, but placing the u8 encryption_type field between two int
fields creates 3 bytes of padding. This is minor, but in a filesystem with
many ordered extents, it could add up. The current placement does have the
advantage of grouping encryption-related fields together logically, though.

>  	/* Qgroup reserved space */
>  	int qgroup_rsv;
>
> @@ -133,6 +136,9 @@ struct btrfs_ordered_extent {
>  	/* the inode we belong to */
>  	struct btrfs_inode *inode;
>
> +	/* the fscrypt_info for this extent, if necessary */
> +	struct fscrypt_extent_info *fscrypt_info;
> +
>  	/* list of checksums for insertion when the extent io is done */
>  	struct list_head list;

How does btrfs_split_ordered_extent() handle the new fscrypt_info field?
Looking at that function in ordered-data.c, it calls alloc_ordered_extent()
which initializes encryption_type to BTRFS_ENCRYPTION_NONE and fscrypt_info
to NULL. If the original ordered extent has encryption_type set to
BTRFS_ENCRYPTION_FSCRYPT with a non-NULL fscrypt_info pointer, the split
creates an inconsistency where the two extents representing parts of the
same encrypted data have different encryption metadata.

The function already has an assertion preventing splits of compressed
extents at line 1244:

    ASSERT(!(flags & (1U << BTRFS_ORDERED_COMPRESSED)))

Should there be similar protection for encrypted extents, or if splits must
be supported, should the function call fscrypt_get_extent_info() to
properly handle the reference count and copy the encryption_type to the new
extent?


