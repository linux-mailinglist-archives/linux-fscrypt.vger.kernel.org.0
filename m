Return-Path: <linux-fscrypt+bounces-1127-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0Lh4MCmniGmjtQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1127-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:09:29 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E2CC1090ED
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:09:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2461D300B3E0
	for <lists+linux-fscrypt@lfdr.de>; Sun,  8 Feb 2026 15:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEDE335EDAD;
	Sun,  8 Feb 2026 15:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Om0u5Ktw"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E8435E557;
	Sun,  8 Feb 2026 15:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770563364; cv=none; b=RvsydG/vH/vFw3DQXQ+O19iJgycnsB6IhlA9gQNQml/sLdbrvfqzLKY5mx4wZnZvNg+wOzEqPriqbH9pS4WdU8y1RpnqlYLqcmevlUh9Ep+HOPgKdntjYWYcU4vfmNb5lZ3yzHfBPzUnaowdszGx1erG1VdccPA2f3y9ipkcLdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770563364; c=relaxed/simple;
	bh=3neiNLk4u4VwSuWZwe9NkSWRJmEK651pdu3s9jJrSrs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=boObITRRzNnNkBSdry3r7hb8wPVzFJnCfaMogSq9K/f3u98poMNk7X4fMT1UM4QlYjboHSH6URuT4UMobcOE60iZ98VOmA2bHlpJhmk7Ynz3rxZnziHIsZGUhNzRSrk5dYs83RnY5W7hP4Tsc1KKZXsF5Xildwlj3Mg2sVvdrPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Om0u5Ktw; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6186tqhZ1521963;
	Sun, 8 Feb 2026 07:09:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=LeYBnQUa05HszJPI2FWyNeCLdj7MlPcVLIWERXy9/+Q=; b=Om0u5Ktw9voh
	kJmMyd/bLyF40zoBKZeneTRsG6wgReBj/bcjjea3IibjEErnOeqpNSQ86t9RxYHc
	Ovq6pSWAmTihkxOQYamftNG97BX8yqSC5L12OmScZzAecan+9gc1kjlrutUZUIOX
	oIciDSwDxbCy6mE547UijnnBAfN+wgHvdE8vMtFSOiOtD/h5T6TtO2uvJ2I91yRS
	J9kRp5jvGbppyLW870kCwp8CJdg2mQWrMl+xwJLZhAAsnCjvnZSWicVkjQ0XOCTQ
	SDE8Cm9BjyJySDDhZFe0oXetmbwqSPOEJJEri1EttrLtoP9pa72qHNb+MBcH/1mK
	VhOs1GBSvg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c62a28tq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 08 Feb 2026 07:09:09 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Sun, 8 Feb 2026 15:09:08 +0000
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
Subject: Re: [PATCH v6 33/43] btrfs: implement read repair for encryption
Date: Sun, 8 Feb 2026 07:08:09 -0800
Message-ID: <20260208150854.3090411-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206182336.1397715-34-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-34-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDEzMCBTYWx0ZWRfX8OzIVp7dWs4s
 EYIVBARgDIj2/GQe9p5Edsv8lzXXxrmdE5e6DNDiQh1c+CzW6LJOTA+nu+j88lL4NRKeNcDeivC
 CwFXpbKqXU3SXnUHpTKBla/uddJSL0NNTjVZDC3WfIJWxXT/54KT3ASO8NcjFqwAUXRitWQ4xGs
 7aUvWntkY4Pdot6B8eEmroI7py/m9AFINWiTnlAqhD4DKL59VEi0GsFMpEtvS+a0kAZoQroSLyS
 vL239E7rSr8mz8RdnyqoREg/z0n3P7xYHg/Q9aZ3dwj1bbfBJ39U8V5tVPGvIVrf3vwWJXYXOhF
 OhJiyGu+9hXNsafwkMlAanpx5Apr56Y+CvIpUCPgcD7TdEig7XmhmxSu+ngxJOmk0ZaX5UsiEwl
 g3ITEWq8lkVyJd2xdfWRWHIhJpNnnuF8K/u1E31sWrLRXDJwBr3teIAPNKBwpSmf3j9mS2PBePp
 Uxbf0x41vB8387jV3Yg==
X-Proofpoint-ORIG-GUID: sPnkyZa3yx0_7rUv41N76fYJWnPkIpPP
X-Authority-Analysis: v=2.4 cv=I9Bohdgg c=1 sm=1 tr=0 ts=6988a715 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8 a=iox4zFpeAAAA:8 a=maIFttP_AAAA:8
 a=s25N_tvCWcG69SwUoj8A:9 a=WzC6qhA0u3u7Ye7llzcV:22 a=qR24C9TJY6iBuJVj_x8Y:22
X-Proofpoint-GUID: sPnkyZa3yx0_7rUv41N76fYJWnPkIpPP
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1127-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:mid,meta.com:dkim,toxicpanda.com:email,suse.com:email]
X-Rspamd-Queue-Id: 5E2CC1090ED
X-Rspamd-Action: no action

Daniel Vacek <neelx@suse.com> wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> In order to do read repair we will allocate sectorsize bio's and read
> them one at a time, repairing any sectors that don't match their csum.
> In order to do this we re-submit the IO's after it's failed, and at this
> point we still need the fscrypt_extent_info for these new bio's.
> 
> Add the fscrypt_extent_info to the read part of the union in the
> btrfs_bio, and then pass this through all the places where we do reads.
> Additionally add the orig_start, because we need to be able to put the
> correct extent offset for the encryption context.
> 
> With these in place we can utilize the normal read repair path.  The
> only exception is that the actual repair of the bad copies has to be
> triggered from the ->process_bio callback, because this is the encrypted
> data.  If we waited until the end_io we would have the decrypted data
> and we don't want to write that to the disk.  This is the only change to
> the normal read repair path, we trigger the fixup of the broken sectors
> in ->process_bio, and then we skip that part if we successfully repair
> the sector in ->process_bio once we get to the endio.

Hi everyone,

I'm running the btrfs for-next branch, along with the encryption patch set
through my AI review prompts:

https://github.com/masoncl/review-prompts

I'm working on some btrfs specific instructions, but hopefully these reviews
are already useful.  I've kept the headers to make it easier to double check
that I'm actually replying to the right email, but please let me know if any
parts of this are incorrect:

commit 096c17a6a951ed0c1100e863c4ee3a95bab0ad51
Author: Josef Bacik <josef@toxicpanda.com>

btrfs: implement read repair for encryption

This commit implements read repair functionality for encrypted btrfs
files by adding fscrypt_extent_info tracking to the btrfs_bio structure
and handling repair operations before decryption occurs.

> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index c28f3f53bad28..e82de96b533cb 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c

[ ... ]

> @@ -293,6 +323,13 @@ static struct btrfs_failed_bio *repair_one_sector(struct btrfs_bio *failed_bbio,
>  	repair_bbio = btrfs_bio(repair_bio);
>  	btrfs_bio_init(repair_bbio, failed_bbio->inode, failed_bbio->file_offset + bio_offset,
>  		       NULL, fbio);
> +	repair_bbio->fscrypt_info = fscrypt_get_extent_info(failed_bbio->fscrypt_info);
> +	repair_bbio->orig_start = failed_bbio->orig_start;
> +
> +	btrfs_set_bio_crypt_ctx_from_extent(repair_bio, repair_bbio->inode,
> +					    failed_bbio->fscrypt_info,
> +					    repair_bbio->file_offset -
> +					    failed_bbio->orig_start);
>
>  	mirror = next_repair_mirror(fbio, failed_bbio->mirror_num);
>  	btrfs_debug(fs_info, "submitting repair read to mirror %d", mirror);

[ ... ]

> @@ -214,17 +244,17 @@ static void btrfs_end_repair_bio(struct btrfs_bio *repair_bbio,
>  			goto done;
>  		}
>
> +		btrfs_set_bio_crypt_ctx_from_extent(&repair_bbio->bio,
> +						    repair_bbio->inode,
> +						    repair_bbio->fscrypt_info,
> +						    repair_bbio->file_offset -
> +						    repair_bbio->orig_start);
> +
>  		btrfs_submit_bbio(repair_bbio, mirror);
>  		return;
>  	}
>
> -	do {
> -		mirror = prev_repair_mirror(fbio, mirror);
> -		btrfs_repair_io_failure(fs_info, btrfs_ino(inode),
> -				  repair_bbio->file_offset, fs_info->sectorsize,
> -				  logical, paddrs, step, mirror);
> -	} while (mirror != fbio->bbio->mirror_num);
> -
> +	handle_repair(repair_bbio, paddrs);
>  done:
>  	btrfs_repair_done(fbio);
>  	bio_put(&repair_bbio->bio);

Does this leak the fscrypt_extent_info reference acquired at line 326?
In repair_one_sector(), repair_bbio->fscrypt_info is set via
fscrypt_get_extent_info(failed_bbio->fscrypt_info), but when
btrfs_end_repair_bio() completes at the done label, it calls
bio_put(&repair_bbio->bio) without calling
fscrypt_put_extent_info(repair_bbio->fscrypt_info) first.

> diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
> index 456d32db9e9e9..7a8ff4378cba0 100644
> --- a/fs/btrfs/bio.h
> +++ b/fs/btrfs/bio.h

[ ... ]

> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 5a39f707c2933..afc461d7642e4 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -562,6 +562,8 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
>  	cb->compress_type = btrfs_extent_map_compression(em);
>  	cb->orig_bbio = bbio;
>  	cb->bbio.csum_search_commit_root = bbio->csum_search_commit_root;
> +	cb->bbio.fscrypt_info = fscrypt_get_extent_info(em->fscrypt_info);
> +	cb->bbio.orig_start = 0;
>
>  	btrfs_set_bio_crypt_ctx_from_extent(&cb->bbio.bio, inode, em->fscrypt_info, 0);
>  	btrfs_free_extent_map(em);

Does this leak the fscrypt_extent_info reference in the compressed read
path? At line 565, fscrypt_get_extent_info() acquires a reference and
stores it in cb->bbio.fscrypt_info. Looking at end_bbio_compressed_read()
in compression.c, it calls btrfs_bio_end_io(cb->orig_bbio, status) which
releases the ORIGINAL bbio's fscrypt_info, but then calls bio_put(cb_bio)
without calling fscrypt_put_extent_info(cb->bbio.fscrypt_info). The error
path in cleanup_compressed_bio() also calls bio_put() without releasing
the cb->bbio.fscrypt_info reference.

[ ... ]



