Return-Path: <linux-fscrypt+bounces-1128-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iGTjDM2niGk/tgQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1128-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:12:13 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8C410912A
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:12:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BE55F3001A6F
	for <lists+linux-fscrypt@lfdr.de>; Sun,  8 Feb 2026 15:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93F9135F8A3;
	Sun,  8 Feb 2026 15:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="nUx/8Aw9"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A132D372D;
	Sun,  8 Feb 2026 15:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770563527; cv=none; b=eVP0nMMjXJUCSIXzy9EH53HbMe68qhJG5TltD8SwDTOiIkMmPlKWoXY1jXJACz3alyBfs2tYXf66CakXldASkCdrRlzlxm22pisLmSYMF+H0BL2xhB3FU7t8ahRydTuCFpVzrNdjqiIc3mwCmreUPw3YeKYX/vi7T6WiCEIkErs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770563527; c=relaxed/simple;
	bh=Drkq/BDAFnD5xhs3mJNAUSMD6hQ5gH+PSa21YOXpAac=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FWlni0B20We7a4SB4k6XOobJEzy8xsxOos1UMCNojKKVlSjd9ipHiWC8WUcKx4NFpwIFds2wZKkEJv54mHJx7dzBr+fgiZX3O0YdbRh1amzZ/WrQLzLQTQtipPTYcn74mcvxNr69BH3e2Zm9JjkbjKqjVzjT18330uZX5pv5xx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=nUx/8Aw9; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 617NbRHM559627;
	Sun, 8 Feb 2026 07:11:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=r/nGh48FEWFxbheQwIQntWKUrVO72sU8M79Y1qsXnLY=; b=nUx/8Aw9LDEH
	fEZVCAc1IK/88odHGOZT3/92mShZukgiQGT52IvmJB+1Pu6BUDAds3vbyeimENDF
	L1pMm6B/E/hVOf097uONq3UGQ/bdaV0kVmh8FaoXVfvggofW70zZP8euyjAIbKBF
	klSaixgt4K4dKWc5fU26g+k9mN4ljsE861TXF8gc5glXBDfC/XkOPYQb6lW6L6VQ
	jp0/S1GF/TBgP6rgLpP/nNwdAR5LXCGLAZi1DjvT+VorIvmi7x644dQ7Qns3QoQF
	q9jWSYJU52cGiG/9Jka0+73ILrPOXoykWYZ9fiN0pevi9Noj4KNO8A3ubTKyl98r
	d4AMZYclhA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c65jjyvkc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 08 Feb 2026 07:11:43 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Sun, 8 Feb 2026 15:11:41 +0000
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
Subject: Re: [PATCH v6 32/43] btrfs: implement process_bio cb for fscrypt
Date: Sun, 8 Feb 2026 07:10:49 -0800
Message-ID: <20260208151126.3129410-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206182336.1397715-33-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-33-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: WRUgHs9CP0sF98_WE6RRrg4sgWbZQ_-x
X-Proofpoint-GUID: WRUgHs9CP0sF98_WE6RRrg4sgWbZQ_-x
X-Authority-Analysis: v=2.4 cv=HM/O14tv c=1 sm=1 tr=0 ts=6988a7af cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8 a=iox4zFpeAAAA:8 a=maIFttP_AAAA:8
 a=b7SsOU8B4G3tYiGgHv4A:9 a=WzC6qhA0u3u7Ye7llzcV:22 a=qR24C9TJY6iBuJVj_x8Y:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDEzMCBTYWx0ZWRfX25k8aHU6nF4U
 H5pcVHUlhdGvPqiinOpnYIENdiM//oTH7Uc4UrCJpZpHeRa64bq8O+eqvV5Jef1Xoj5mECBUPs5
 8xaLC2/xo1vM7QH2bBJA6QWgo542/QszQRbMyaA42UzcKHotAZoFU1IN/BApy16I3CcHYJN3C1g
 5XRkgSTsS2QiTEg2pC8QwrDXmrwl56eXyeW9hI0myfJ/IfyCYqQqIBPZne3VvvuoJ+4tePIn3IM
 +Un0HGQAW6GT3+OIY9rTDXMV8mtK6qizCsStY8DgvhWBdW9lboDLUSLsjg6DWHqbpBrf6xqzE1w
 AWrS6+NjWWXXL8oiNge52tqMjbTZm9YMJDcFbbwra1H9WaEOUFwvMPw5wAYAoJn7ORKLgTItK2+
 pvV/4nxIQYMklOKznlRqbuhEF452Uo1Am1sZGpKOIraR21elW2guavzrqfNc58H3CAt/+DubuyA
 py3hgXrExtsOO6V/plA==
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
	TAGGED_FROM(0.00)[bounces-1128-lists,linux-fscrypt=lfdr.de];
	DKIM_TRACE(0.00)[meta.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clm@meta.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:mid,meta.com:dkim,toxicpanda.com:email,suse.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4C8C410912A
X-Rspamd-Action: no action

Daniel Vacek <neelx@suse.com> wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> We are going to be checksumming the encrypted data, so we have to
> implement the ->process_bio fscrypt callback.  This will provide us with
> the original bio and the encrypted bio to do work on.  For WRITE's this
> will happen after the encrypted bio has been encrypted.  For READ's this
> will happen after the read has completed and before the decryption step
> is done.
> 
> For write's this is straightforward, we can just pass in the encrypted
> bio to btrfs_csum_one_bio and then the csums will be added to the bbio
> as normal.
> 
> For read's this is relatively straightforward, but requires some care.
> We assume (because that's how it works currently) that the encrypted bio
> match the original bio, this is important because we save the iter of
> the bio before we submit.  If this changes in the future we'll need a
> hook to give us the bi_iter of the decryption bio before it's submitted.
> We check the csums before decryption.  If it doesn't match we simply
> error out and we let the normal path handle the repair work.

Hi everyone,

I'm running the btrfs for-next branch, along with the encryption patch set
through my AI review prompts:

https://github.com/masoncl/review-prompts

I'm working on some btrfs specific instructions, but hopefully these reviews
are already useful.  I've kept the headers to make it easier to double check
that I'm actually replying to the right email, but please let me know if any
parts of this are incorrect:

commit 2b25418669e46c939ff864b1144e2c27d618920c
Author: Josef Bacik <josef@toxicpanda.com>

btrfs: implement process_bio cb for fscrypt

This commit implements the ->process_bio fscrypt callback for btrfs,
enabling checksum verification of encrypted data before decryption and
checksum generation after encryption.

> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 3b420866f3b82..c28f3f53bad28 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -300,6 +300,34 @@ static struct btrfs_failed_bio *repair_one_sector(struct btrfs_bio *failed_bbio,
>  	return fbio;
>  }
>
> +blk_status_t btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio, struct bio *enc_bio)
> +{
> +	struct btrfs_inode *inode = bbio->inode;
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	struct bvec_iter iter = bbio->saved_iter;
> +	struct btrfs_device *dev = bbio->bio.bi_private;
> +	const u32 step = min(fs_info->sectorsize, PAGE_SIZE);
> +	const u32 nr_steps = iter.bi_size / step;
> +	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];

Can paddrs[] overflow here? BTRFS_MAX_BLOCKSIZE is 64KB, so the array
has 16 elements (64KB / 4KB). However, nr_steps is calculated from
iter.bi_size which can be much larger than 64KB for merged bios.

If a bio has bi_size > 64KB, the loop below will write beyond the array
bounds when filling paddrs[slot].

> +	phys_addr_t paddr;
> +	unsigned int slot = 0;
> +
> +	/*
> +	 * We have to use a copy of iter in case there's an error,
> +	 * btrfs_check_read_bio will handle submitting the repair bios.
> +	 */
> +	btrfs_bio_for_each_block(paddr, enc_bio, &iter, step) {
> +		ASSERT(slot < nr_steps);
> +		paddrs[slot] = paddr;
> +		slot++;
> +	}
> +	if (!btrfs_data_csum_ok(bbio, dev, 0, paddrs))

Does this verify checksums for all sectors in the bio? Looking at
btrfs_data_csum_ok() in inode.c, it verifies one sector's worth of data
(one blocksize). The function is called with bio_offset=0, meaning it
only checksums the first sector.

However, the bio can contain multiple sectors (iter.bi_size could be
much larger than one sectorsize). If the bio has multiple sectors,
shouldn't this call btrfs_data_csum_ok() for each sector, or pass the
actual bio size so all sectors are verified?

The existing btrfs_check_read_bio() function loops through all sectors
and verifies each one individually.

> +			return BLK_STS_IOERR;
> +
> +	bbio->csum_ok = true;
> +	return BLK_STS_OK;
> +}

[ ... ]



