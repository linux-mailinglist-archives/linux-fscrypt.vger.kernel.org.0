Return-Path: <linux-fscrypt+bounces-1132-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aGqAL+yqiGn4twQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1132-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:25:32 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D81AE109265
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:25:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C83093001FBF
	for <lists+linux-fscrypt@lfdr.de>; Sun,  8 Feb 2026 15:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4736362141;
	Sun,  8 Feb 2026 15:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="VWBXH0h6"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2E536212C;
	Sun,  8 Feb 2026 15:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770564326; cv=none; b=huGS7J8jMF9tvzVHsLAbYqDBUuxZbwYggpfpXYNESx2zil61wlcq60gC0bAjB0tHSiS4kWjzdBiL2RBmQwBMG57siJ+hS2x3WGnxweYGnWIS51PiVwzZkNbqaTK35w1DdYXq/Bui3BgPBbyqS8UUyNU/E761ZMmxe01GvG1ZF2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770564326; c=relaxed/simple;
	bh=DP9qB4kT2RPoO8+HIWvTaMbKCj3YXUROQlbV/JBCmUU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tdmWnFqq748jAGCKBcOgMFtUHLDXQ89uuWbrrxCP99lZw0w57oyD0sHGoL+Z2CWXpaELTkkpLG/aYB1BzMXd/ADYEkVDp/jtR6KPHTk9knNBGTr73y+wISIXak+oaEkBX3tYR4PxC4R7xs15SX9ohbKIy8XlI0cif/HdeVCkmQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=VWBXH0h6; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6187RFs31736750;
	Sun, 8 Feb 2026 07:25:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=jS5lNycBHXBlrQ4/xNQODTAx1r8ji8mvoa5+W/z2icY=; b=VWBXH0h65wQP
	Sz7m2o+ZU4zHxO+H88N1vUyjLDcVVLdK2CL4iPEpcLQz2RCPjIFElQS6z60O9Y6h
	qPhDWRa/CNeFym8Y+Hj7GCz7wY1T8Q31SjOAch+yYaaJnYuHNeUq3sdRgAo58/TK
	U0rUaWWXt72dWs2yPe8swjVFw74ARx4YN8ZUo3bBsbFmtH9e4DfGVK+0m+MdJutm
	3TdyOART+QuWUfBcQknhtXEBuxFBc6VaJwK7K9keOhrPaCHprshV4dQLjLUb9Gkj
	IW4weSCM2qMISklPlJCxatPHycIJwziWTgFQJyVoGdqYetSsd2rn7EAuOvFyiqcE
	7hL49kD20A==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c67xuy0mv-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 08 Feb 2026 07:25:11 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Sun, 8 Feb 2026 15:25:10 +0000
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
Subject: Re: [PATCH v6 16/43] btrfs: select encryption dependencies if FS_ENCRYPTION
Date: Sun, 8 Feb 2026 07:22:37 -0800
Message-ID: <20260208152448.3300594-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206182336.1397715-17-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-17-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=B6i0EetM c=1 sm=1 tr=0 ts=6988aad7 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8 a=iox4zFpeAAAA:8 a=maIFttP_AAAA:8
 a=-hVligO-2lKxrFAun1gA:9 a=WzC6qhA0u3u7Ye7llzcV:22 a=qR24C9TJY6iBuJVj_x8Y:22
X-Proofpoint-ORIG-GUID: Q2kOkzinV_ne25OF3ftcKSnlrFUQP-Ik
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDEzMyBTYWx0ZWRfX5Ls57kV0gLcv
 +gIAxRtnQfA+TOjJkuu6YlIVYIU62ro8KL7iY3yxSmHEWRZccM2nm4qBLryNuh3X/IMN1HlCH5o
 ms3DPI3WaNF19wXFKWv+oKerbNjH2XU8ctnPvwvE+oHImTML9d0TScG/ALJMpYTg5wwkK7X+hXM
 OIe5RWBtOJspRP2uub/On+Jup/DWBfE8Mx+VL4WV+MGrKc/zvH9JAt8jKialb3XGuYbhV9yLsx3
 t/nocWaibJyHksuUxopWBUPgSNRBEnC3+Mj1wFBEG+U6JVKjcAVGuBx+IQpontap1HwBVFniunN
 5SNCvr+fvrBJM6f8EuK0qh1YdncFQVC1Xqf6O0CczJJOaodH3S/KNcRsSiaX+tSgQvM/TKuWfXR
 yeylvcpIDDNYmvvqf93/1i0g+Y64f6rXJGnpmLhroYw+E/9Qo/aXviVS0JAQj9C1jXMDyHZAEK/
 Zo19RDZCf1dU/5nU/OQ==
X-Proofpoint-GUID: Q2kOkzinV_ne25OF3ftcKSnlrFUQP-Ik
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1132-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:mid,meta.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,toxicpanda.com:email,suse.com:email]
X-Rspamd-Queue-Id: D81AE109265
X-Rspamd-Action: no action

Daniel Vacek <neelx@suse.com> wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> We need this to make sure the appropriate encryption algorithms are
> turned on in our config if we have FS_ENCRYPTION enabled, and
> additionally we only support inline encryption with the fallback block
> crypto, so we need to make sure we pull in those dependencies.

Hi everyone,

I'm running the btrfs for-next branch, along with the encryption patch set
through my AI review prompts:

https://github.com/masoncl/review-prompts

I'm working on some btrfs specific instructions, but hopefully these reviews
are already useful.  I've kept the headers to make it easier to double check
that I'm actually replying to the right email, but please let me know if any
parts of this are incorrect:

commit 0ab45d92f6f53371d87e1a302f09b56218d02546
Author: Josef Bacik <josef@toxicpanda.com>

btrfs: select encryption dependencies if FS_ENCRYPTION

This commit adds select statements for encryption-related dependencies when
FS_ENCRYPTION is enabled, including encryption algorithms, inline crypto, and
the block layer inline encryption fallback.

> diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
> index ede184b6eda16..216a5707b099c 100644
> --- a/fs/btrfs/Kconfig
> +++ b/fs/btrfs/Kconfig
> @@ -16,6 +16,9 @@ config BTRFS_FS
>  	select RAID6_PQ
>  	select XOR_BLOCKS
>  	select XXHASH
> +	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
> +	select FS_ENCRYPTION_INLINE_CRYPT if FS_ENCRYPTION
> +	select BLK_INLINE_ENCRYPTION_FALLBACK if FS_ENCRYPTION

Are the dependencies for FS_ENCRYPTION_INLINE_CRYPT and
BLK_INLINE_ENCRYPTION_FALLBACK satisfied?

Looking at fs/crypto/Kconfig:38, FS_ENCRYPTION_INLINE_CRYPT depends on
'FS_ENCRYPTION && BLK_INLINE_ENCRYPTION'. Similarly, in block/Kconfig:204,
BLK_INLINE_ENCRYPTION_FALLBACK depends on 'BLK_INLINE_ENCRYPTION'.

When BTRFS_FS=y with FS_ENCRYPTION=y but BLK_INLINE_ENCRYPTION=n (which is
valid), Kconfig will generate warnings:

  WARNING: unmet direct dependencies detected for BLK_INLINE_ENCRYPTION_FALLBACK
  WARNING: unmet direct dependencies detected for FS_ENCRYPTION_INLINE_CRYPT

The build will fail when compiling fs/crypto/inline_crypt.c because
BLK_INLINE_ENCRYPTION guards the required function definitions and struct
members:

  fs/crypto/inline_crypt.c:259:15: error: implicit declaration of function
      'blk_crypto_derive_sw_secret'
  fs/crypto/inline_crypt.c:317:9: error: implicit declaration of function
      'bio_crypt_set_ctx'
  fs/crypto/inline_crypt.c:418:45: error: 'struct bio' has no member named
      'bi_crypt_context'

Should BLK_INLINE_ENCRYPTION also be selected when FS_ENCRYPTION is enabled?

  select BLK_INLINE_ENCRYPTION if FS_ENCRYPTION
  select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
  select FS_ENCRYPTION_INLINE_CRYPT if FS_ENCRYPTION
  select BLK_INLINE_ENCRYPTION_FALLBACK if FS_ENCRYPTION

>  	depends on PAGE_SIZE_LESS_THAN_256KB
>
>  	help


