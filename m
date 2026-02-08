Return-Path: <linux-fscrypt+bounces-1129-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cOYvM0moiGnJtgQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1129-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:14:17 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D79F010914D
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:14:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0F6013001A7D
	for <lists+linux-fscrypt@lfdr.de>; Sun,  8 Feb 2026 15:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CA2635F8A9;
	Sun,  8 Feb 2026 15:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="TtwIZMJq"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AD02D372D;
	Sun,  8 Feb 2026 15:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770563652; cv=none; b=oJqQ+YcQJxCRe1mpO6XeCPgcLWgUONTuT4G+HNvx0rkJdO9Wkqb010JDsOGkdMYL4nizPqo0w9VkyOfasjsF6sMEcn7Bgw6cfMX8FYn+quVBts4eKtxVLv90UWQlQBewMLzeeh0ZTt3fm17ppqzbQ1pQMKo/3a64iuSI74ZtzHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770563652; c=relaxed/simple;
	bh=+Km8WVme9lq1ZYS5ZyOSWWNqxtZTb1ziZjNdabnPWA8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bDDv8KiTLUURzNzdSdXJ5JmiFELJjAW+NTX7eS1DjrjTGlgs22pCwg2EOUsfBSzQ+P1mUEdtXztPqeBoWblAg1AS+5RKE0Qmmb+4jbLD4aVIlRjUax2E+I9k2YtiUD0r80qmVsERiAYa6jDE+m6iZ5vkNwekZqfehUrRCaxgjVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=TtwIZMJq; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 617MQ4hd3487875;
	Sun, 8 Feb 2026 07:14:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=nMJNYKSSfYRuYPs6VhC0kEvCORLSt70hah9azLmCH88=; b=TtwIZMJqo4so
	I0ApiQ0rPjhKGFx5KwyKiNcnZpzfFOGJOcv1kjigFKWXafhlhUBk773fv7Eny18N
	5PLCrYnaSmaS1EaXsnHSACtvmqnwuVC2BIS2LqTIpemgKOym9JoX8U6eUlthfRuH
	Jy4l1C2mZEg7p4AG9RIlC3zM6Zqw4xxZzGsnykhMuapJPDJU1UMgykAF4Wq88BFw
	MNjOKngHyhQhx4ST29OS464Ep10fXTFJJ4Eybrx8ZUtZmYyqxc1M+7e+jzo9evqJ
	cK5Ys+ZF6YfnKI6HLXLDzord4CFHkTwicbx2UU4gmQiNCZbdbqJgZQdQ+qP3R/5i
	b5avX9kcww==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c63se0c1u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 08 Feb 2026 07:14:05 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Sun, 8 Feb 2026 15:14:04 +0000
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
Subject: Re: [PATCH v6 28/43] btrfs: populate ordered_extent with the orig offset
Date: Sun, 8 Feb 2026 07:12:12 -0800
Message-ID: <20260208151350.3147841-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206182336.1397715-29-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-29-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 00nzG4KNdQAtRN9LqHVFSLtqbdU73Mwj
X-Proofpoint-GUID: 00nzG4KNdQAtRN9LqHVFSLtqbdU73Mwj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDEzMCBTYWx0ZWRfX/QFYX699UENY
 gPwX2x9yyYEFkY4+0bn7pj/0XSd3Mu0awOhUMaHeTFp7rgRJUhXPBzW/hOg0VTcgxLAyzkXrZTq
 9OhIEAl9T9GTQr5PLJlknSqwv3WIqJs4nB7LGFnTyhe3TcCJ5CqHjKTDfYvHvwMWIxVQx9Z4Uka
 UCogbJlPeGzm3BPzwZIYQlnEEmnqUO2rkvbpP8dqYNxjqw77QiJpqa7jQNv7IIWZ2WYz7DllHsH
 F1UrYlwjH9BOIW3JRPJGd3XgkfpuL0JpQy+4KeC1EkN3HYav9EnqeKyhI0fh7wgkIP8XZAy+RHX
 syIpPtSu2sGKprJZ5ViSM3m8MOB7Xt4o9Wz7vnUEqE8Ed9dW6iC0wonVrUiPGrjQwTHNoFcniR1
 54jRWZmimGSnrFYicVQhhh1oaHEJuPJGa0gJAezf3j0FH314qK4FSXvlfViqDx4Zi+GKk1nDaBq
 UjGqpEw+L+ihhFC90Tw==
X-Authority-Analysis: v=2.4 cv=G7wR0tk5 c=1 sm=1 tr=0 ts=6988a83d cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8 a=iox4zFpeAAAA:8 a=maIFttP_AAAA:8
 a=MiC5QLDax9SJ5MPSigIA:9 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19
 a=WzC6qhA0u3u7Ye7llzcV:22 a=qR24C9TJY6iBuJVj_x8Y:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_03,2026-02-05_03,2025-10-01_01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1129-lists,linux-fscrypt=lfdr.de];
	DKIM_TRACE(0.00)[meta.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clm@meta.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:mid,meta.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,toxicpanda.com:email,suse.com:email]
X-Rspamd-Queue-Id: D79F010914D
X-Rspamd-Action: no action

Daniel Vacek <neelx@suse.com> wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> For extent encryption we have to use a logical block nr as input for the
> IV.  For btrfs we're using the offset into the extent we're operating
> on.  For most ordered extents this is the same as the file_offset,
> however for prealloc and NOCOW we have to use the original offset.
> 
> Add this as an argument and plumb it through everywhere, this will be
> used when setting up the bio.
> 

Hi everyone,

I'm running the btrfs for-next branch, along with the encryption patch set
through my AI review prompts:

https://github.com/masoncl/review-prompts

I'm working on some btrfs specific instructions, but hopefully these reviews
are already useful.  I've kept the headers to make it easier to double check
that I'm actually replying to the right email, but please let me know if any
parts of this are incorrect:

commit 0e7f6a617a2642bbdf97bcd639fb887fa88189ad
Author: Josef Bacik <josef@toxicpanda.com>

btrfs: populate ordered_extent with the orig offset

This commit adds orig_offset tracking to btrfs_ordered_extent and
btrfs_file_extent structures for extent encryption support, where the
offset into the extent is needed for IV generation.

> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index d3789109ca851..2d89ac05b1b38 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -155,6 +155,7 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
>  		file_extent->fscrypt_info = em->fscrypt_info;
>  	}
>
> +	file_extent->orig_offset = start - file_extent->offset;
>  	ordered = btrfs_alloc_ordered_extent(inode, start, file_extent,
>  					     (1U << type) |
>  					     (1U << BTRFS_ORDERED_DIRECT));

[ ... ]

> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index fbb968d4010b7..8078049f690e1 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c

[ ... ]

> @@ -2296,6 +2298,8 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
>  			cow_start = (u64)-1;
>  		}
>
> +		nocow_args.file_extent.orig_offset =
> +			found_key.offset - nocow_args.file_extent.offset;
>  		ret = nocow_one_range(inode, locked_folio, &cached_state,
>  				      &nocow_args, cur_offset,
>  				      extent_type == BTRFS_FILE_EXTENT_PREALLOC);

Should this calculation use cur_offset instead of found_key.offset?

Looking at the DIO path in btrfs_create_dio_extent() (direct-io.c line
158), the orig_offset is calculated as:

    file_extent->orig_offset = start - file_extent->offset;

where 'start' is the current write position. In run_delalloc_nocow(),
found_key.offset represents where the extent item is stored, while
cur_offset represents the current write position (analogous to 'start'
in the DIO path).

When writing to a position within an existing extent (not at its start),
using found_key.offset - file_extent.offset could produce incorrect
values. For consistency with the DIO path, would the formula be:

    nocow_args.file_extent.orig_offset =
        cur_offset - nocow_args.file_extent.offset;

This would ensure that NOCOW writes calculate orig_offset the same way
as DIO writes, which matters for encryption IV generation where an
incorrect offset would cause data corruption on reads.


