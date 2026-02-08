Return-Path: <linux-fscrypt+bounces-1125-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AO+qHyONiGk/rAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1125-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 14:18:27 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 27761108BBE
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 14:18:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8C940300362A
	for <lists+linux-fscrypt@lfdr.de>; Sun,  8 Feb 2026 13:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF7C12673A5;
	Sun,  8 Feb 2026 13:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="tzvxrYbg"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE7E2441B8;
	Sun,  8 Feb 2026 13:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770556702; cv=none; b=B8gTAJSwGuKtj9pmINDN/nlK10qeCp4oI9BKMG81OpX/wdpOKMvNyvs0J8emkF5hNtGVzLCeDpmXNSqDe6/zvUhiciA5LbcAgbHzF56VNEgQIo9SBYuOKsk2I6SYxbo/bvuglJaHvOq0LMRZ2xCuhGZpFBbKA2A/3+vAufELsq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770556702; c=relaxed/simple;
	bh=6g7r4VhyG2HWU2AYFMAFpaO5CaVLc2pDSZumZIwZRhc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pFCXJVOJjT2lvI0Mc5X461VMFzNQWqRfUatFq3qLEMGUAHdp8PLD026CUviyqQ8iIKkHonW+1o51r4rOrvub6gEqNaBG4tJlNR9+J5H9BmrF3fg+E6DPE3+aipwsFJs6QwdDWW8lVEmJA+WoDNrVh4AB9/SLAKDbSuMSveM2EDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=tzvxrYbg; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 618AgKIA3236267;
	Sun, 8 Feb 2026 05:18:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=EoIGrtxRRxbLe6X5l7v6Y8YnpXO4kkvbtEF10x8BiKM=; b=tzvxrYbgvJ7m
	yMpJE6HFAcFRO8A43tbclIpmnm81NtmcamRJcAOzryO6VYg3/AmLKj+Wb9P0Ureh
	B1w5W3x1Y/bihdOX6Fzg6RCVIlL33h6yglGE8l/3VOLzzSVbEJ370XNTJKS6nRCj
	DIa5xMwnDQiXXe6KJYro/bMQFTDS0MThkZaZHQvUS/z8OJwWEBxVhwWrHbjYv9kx
	CY5tBAJY6R26BQEf48+eoJyscbsW+NrSBgfUEOsK703/YwGuEKIlBB2kuEq5wchk
	CU3P2A6rTGgN3d1H0HoZ7JDCbVS8nFPrc1rdlLGSoyW1Vk6txt2WIxbEnWY4cf7Y
	+Mn76kRQ3w==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c65jjyae2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 08 Feb 2026 05:18:02 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Sun, 8 Feb 2026 13:18:01 +0000
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
Subject: Re: [PATCH v6 42/43] btrfs: disable encryption on RAID5/6
Date: Sun, 8 Feb 2026 05:14:57 -0800
Message-ID: <20260208131745.2173841-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206182336.1397715-43-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-43-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7iQgHGVSyDzV3k5FuRLTuk2jnpqHCaIw
X-Proofpoint-GUID: 7iQgHGVSyDzV3k5FuRLTuk2jnpqHCaIw
X-Authority-Analysis: v=2.4 cv=HM/O14tv c=1 sm=1 tr=0 ts=69888d0a cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8 a=iox4zFpeAAAA:8 a=maIFttP_AAAA:8
 a=ojOyy3yCrAsgUvTcCNgA:9 a=WzC6qhA0u3u7Ye7llzcV:22 a=qR24C9TJY6iBuJVj_x8Y:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDExNCBTYWx0ZWRfXzZIM0D/1NVfr
 kqj+8zRW0/jVFSS58zxu4ZPvxigFu1ElLZQaBuDDwrS4M77TdhrS1RybeRQLc2LEcIr39BauKQX
 hqc47XCARcw84SZH7BRrPpnL0/tR54KjQNjGES37J5yh+j4Y8Fk6G8GXuuE2vzYeR0HjflaLoGc
 DUqqn7vb1gEx/UtvQAcXMOZvaBv6KN9LB4locuGOnXje6KwxAXIldo1/TZbak+jkkHHd0hWEY6p
 MU+QHiVV/oJqdQHLwTvz9mjZS1zGMHyNsLc5D0wW09CXGjNLrrMazrkUsX7agJgxL15cn443rvv
 E5mUJXkHNTZRlolrWTuni9BR6SB8fxF0a+HMNLSq4qITUcVpbxnjZtaQlMaPL9mOigD8PdCZ9eM
 bQZrgv/Zl8uw79aWvXKlAtXqj+3+zPszAXKAwPVyKQzIiMp0KPGLKgU7h2pqWN2L4waOccEOFYZ
 jGA7Icap9060e7NCW4A==
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1125-lists,linux-fscrypt=lfdr.de];
	DKIM_TRACE(0.00)[meta.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clm@meta.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.com:email,toxicpanda.com:email,meta.com:mid,meta.com:dkim]
X-Rspamd-Queue-Id: 27761108BBE
X-Rspamd-Action: no action

Daniel Vacek <neelx@suse.com> wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> The RAID5/6 code will re-arrange bios and submit them through a
> different mechanism.  This is problematic with inline encryption as we
> have to get the bio and csum it after it's been encrypted, and the
> radi5/6 bio's don't have the btrfs_bio embedded, so we have no way to
> get the csums put on disk.
> 
> This isn't an unsolvable problem, but would require a bit of reworking.
> Since we discourage users from using this code currently simply don't
> allow encryption on RAID5/6 setups.  If there's sufficient demand in the
> future we can add the support for this.
> 

Hi everyone,

I'm running the btrfs for-next branch, along with the encryption patch set
through my AI review prompts:

https://github.com/masoncl/review-prompts

I'm working on some btrfs specific instructions, but hopefully these reviews
are already useful.  I've kept the headers to make it easier to double check
that I'm actually replying to the right email, but please let me know if any
parts of this are incorrect:


commit 6a39a21e95e116ad02c6ce9f832838acc111692f
Author: Josef Bacik <josef@toxicpanda.com>

btrfs: disable encryption on RAID5/6

The RAID5/6 code will re-arrange bios and submit them through a
different mechanism to handle parity. This is problematic with inline
encryption as we have to get the bio and csum it after it's been
encrypted, and the RAID5/6 bios don't have the btrfs_bio embedded, so
there's no way to get the csums put on disk.

> commit 6a39a21e95e116ad02c6ce9f832838acc111692f
> Author: Josef Bacik <josef@toxicpanda.com>
> Date:   Fri Feb 6 19:23:14 2026 +0100
>
>     btrfs: disable encryption on RAID5/6
>
>     The RAID5/6 code will re-arrange bios and submit them through a
>     different mechanism.  This is problematic with inline encryption as we
>     have to get the bio and csum it after it's been encrypted, and the
>     radi5/6 bio's don't have the btrfs_bio embedded, so we have no way to
                                                                       ^^^^

This isn't a bug, but there's a typo: 'radi5/6' should be 'raid5/6'.

[ ... ]

>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a8adf99ad0a81..1bade8fea16e8 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -5198,6 +5198,10 @@ long btrfs_ioctl(struct file *file, unsigned int
>  			return -EOPNOTSUPP;
>  		if (sb_rdonly(fs_info->sb))
>  			return -EROFS;
> +		if (btrfs_fs_incompat(fs_info, RAID56)) {
> +			btrfs_warn(fs_info, "can't enable encryption with RAID5/6");
> +			return -EINVAL;
> +		}

This check prevents enabling encryption when RAID56 is already active,
but does NOT prevent converting to RAID5/6 after encryption is enabled.
The check_raid56_incompat_flag() function in fs/btrfs/volumes.c:5558
sets the RAID56 flag during balance operations without checking if
ENCRYPT is already set. This allows users to:

1. Enable encryption via FS_IOC_SET_ENCRYPTION_POLICY (sets ENCRYPT at
   line 5210 in this function)
2. Later run btrfs balance to convert to RAID5/6 (sets RAID56 flag at
   volumes.c:5558)
3. End up with both ENCRYPT and RAID56 flags set

The commit message states "simply don't allow encryption on RAID5/6
setups" which implies preventing the incompatible state entirely, not
just one entry path. The volumes.c code path needs a corresponding
check:

static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
{
	if (!(type & BTRFS_BLOCK_GROUP_RAID56_MASK))
		return;
	// MISSING: check for ENCRYPT flag here
	btrfs_set_fs_incompat(info, RAID56);
}

Without this check, data corruption can occur via the RAID5/6 bio path
that cannot handle encrypted data properly, as explained in the commit
message.

> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 4a2887147ead4..aefcbe56e85ad 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -734,6 +734,12 @@ bool btrfs_check_options(const struct btrfs_fs_info *info,
>  	if (btrfs_check_mountopts_zoned(info, mount_opt))
>  		ret = false;
>
> +	if (btrfs_fs_incompat(info, RAID56) &&
> +	    btrfs_raw_test_opt(*mount_opt, TEST_DUMMY_ENCRYPTION)) {
> +		btrfs_err(info, "cannot use test_dummy_encryption with RAID5/6");
> +		ret = false;
> +	}
> +

Similar to the ioctl.c issue, this prevents mounting with
test_dummy_encryption when RAID56 is already active, but does NOT
prevent converting to RAID5/6 after mounting with test_dummy_encryption.

The check_raid56_incompat_flag() function in fs/btrfs/volumes.c:5558
sets the RAID56 flag during balance operations without checking if
test_dummy_encryption is in use. Since test_dummy_encryption cannot be
changed after mount (enforced by btrfs_check_test_dummy_encryption at
line 1547-1560), a user can:

1. Mount filesystem with -o test_dummy_encryption
2. Later run btrfs balance to convert to RAID5/6 (sets RAID56 flag)
3. End up with both test_dummy_encryption active and RAID56 flag set

While test_dummy_encryption is primarily a testing/development feature,
the patch explicitly protects against this combination, indicating it's
an important incompatibility. The volumes.c code path needs a check for
the TEST_DUMMY_ENCRYPTION mount option:

static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
{
	if (!(type & BTRFS_BLOCK_GROUP_RAID56_MASK))
		return;
	// MISSING: check for TEST_DUMMY_ENCRYPTION mount option
	btrfs_set_fs_incompat(info, RAID56);
}

Does this allow the same encrypted bio / RAID5/6 bio incompatibility
described in the commit message?


