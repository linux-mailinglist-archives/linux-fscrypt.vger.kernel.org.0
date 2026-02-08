Return-Path: <linux-fscrypt+bounces-1126-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8K82M+2liGmjtQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1126-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:04:13 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 30CB510902D
	for <lists+linux-fscrypt@lfdr.de>; Sun, 08 Feb 2026 16:04:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B9DF13011121
	for <lists+linux-fscrypt@lfdr.de>; Sun,  8 Feb 2026 15:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A4EE35D608;
	Sun,  8 Feb 2026 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="fh0T654m"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E8631281D;
	Sun,  8 Feb 2026 15:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770563051; cv=none; b=GrsORgxx4Xw4jzGbIuOj9gDSHKWyK+AAZwqAqYE2jeCGqcty++j4hhlT7IsqFxmcaULrM7LljSSJP6qugs3JFXBtE1UDkcFKCMNboohDfkIoRpfJjDTO0W+2nUyvhSJVtV0DnKqF0Cy/oGw5ov+rdYqAz4he6c/YNjU9YWdYGQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770563051; c=relaxed/simple;
	bh=BR+QwPls3Re9ZJZZhSecsQoLg8DMfRizayWh9+ipyjU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IH2a3GBGHVShTmnDC45unJPgWOqPQytHSrfuDwuLr4rWNBLeBTZQWapt+1xrh7Yw0LFmAHPsujzC/6IUk55zQiPp7CV4Wraj9gM8dbNN0YvTpuyPA48ig1utcUbfP0UC2SVcxjp8sX4RKtaoUPXcHBm3i3HqCHm/i5TXsD8mKHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=fh0T654m; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6182PTSK3970481;
	Sun, 8 Feb 2026 07:03:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=r8TgvkafMV6daSZZO99Yl2Naiajs8VLEhgXLNDiWMJE=; b=fh0T654m9ZCi
	cGpxGunRrUZKymnYWoBz/35YF5bObfEIcd57Xm368weOV0qngml6onHrGVsgZGZh
	qQnvQdkvNnKJ9/YK2TFkb0/exmnSFgr+zGF5KdhoG2yo/buExrbWXh4DiYh1oYmG
	iWZ2rzSMIRNnMtb0wmCIcSWenoxuthIG4/jRqWIucC0XljU5BDv+O3l8e1LemeRf
	BHt07f6I2x3mljIzN+cxLPqDFXsmoxDF5Cca4LbOafueKG9hU3hjX/tyRcoemVax
	mSUuwv701e4nTZ4Biw4AAQ4cllJXeOluG1YGdsxkKg8x+sjSSOMNyejJRbXP6SKd
	q71BNCb/2A==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c67xuxvn2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 08 Feb 2026 07:03:53 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Sun, 8 Feb 2026 15:03:52 +0000
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
Subject: Re: [PATCH v6 35/43] btrfs: make btrfs_ref_to_path handle encrypted filenames
Date: Sun, 8 Feb 2026 07:02:41 -0800
Message-ID: <20260208150339.3021113-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206182336.1397715-36-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-36-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=B6i0EetM c=1 sm=1 tr=0 ts=6988a5d9 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8 a=iox4zFpeAAAA:8 a=maIFttP_AAAA:8
 a=b7SsOU8B4G3tYiGgHv4A:9 a=WzC6qhA0u3u7Ye7llzcV:22 a=qR24C9TJY6iBuJVj_x8Y:22
X-Proofpoint-ORIG-GUID: tKfGaXmVIaT_auK3ixN7MYc6QZxkkdMt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDEyOSBTYWx0ZWRfX6EkpnAIZE1U5
 WOOj/43jRRlyZEkm6NSclSa3V8k9EzmdysCVfX5QBdzDLDz1qlE9OlzaJckm1JnSULrPqE+5563
 uYOxUUPcdB/H9niOqkeEg6KCm0xXWPk1ZicdPcXDVloMBeCEQULlRpy4yWZn0vM3TIKLo7MQu/i
 PTz81VclLFYCdHYjftjafjj+2ewY2sirHjzrQxPmMfvyymZM4/oEhz4IMIvvTMWTBQjAwQnw94A
 TNsyCgC/VzknXJjHCZjaz/OLZZZTm8hMOOFyu9WCYhmPmCb3P2Uze6B0AxpB5F6t3AqaWW0QOAF
 qLAw7YwCRBr2WmCVFJtPWXA6COvHY522+YHy21gi7foBO1apBX0lBYQzwsULXGxKF3aKuy4Yy4p
 o7UlDiBQIjH0ksBa+Lwv4gfubXPnhc+FXzXjYlSvg2djmhj8L/cMqC4DGACjovNiGBTsw4ZSgV1
 iAI+TpYxZkBRRg4xGBw==
X-Proofpoint-GUID: tKfGaXmVIaT_auK3ixN7MYc6QZxkkdMt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_03,2026-02-05_03,2025-10-01_01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1126-lists,linux-fscrypt=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clm@meta.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[meta.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 30CB510902D
X-Rspamd-Action: no action

Daniel Vacek <neelx@suse.com> wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> We use this helper for inode-resolve and path resolution in send, so
> update this helper to properly decrypt any encrypted names it finds.
> 

Hi everyone,

I'm running the btrfs for-next branch, along with the encryption patch set
through my AI review prompts:

https://github.com/masoncl/review-prompts

I'm working on some btrfs specific instructions, but hopefully these reviews
are already useful.  I've kept the headers to make it easier to double check
that I'm actually replying to the right email, but please let me know if any
parts of this are incorrect:


commit 473bbb12052f731a4e2ce3c48e7d7e9f2510528b
Author: Josef Bacik <josef@toxicpanda.com>

btrfs: make btrfs_ref_to_path handle encrypted filenames

This commit updates btrfs_ref_to_path() to handle encrypted filenames by
introducing a new copy_resolved_iref_to_buf() helper that can decrypt
names when the filesystem has encryption enabled.

> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 9bb406f7dd302..577c3ef87791a 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c

[ ... ]

> @@ -2107,6 +2108,39 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
>  	return ret;
>  }
>
> +static int copy_resolved_iref_to_buf(struct btrfs_root *fs_root,
> +				     struct extent_buffer *eb, char *dest,
> +				     u64 parent, unsigned long name_off,
> +				     u32 name_len, s64 *bytes_left)
> +{
> +	struct btrfs_fs_info *fs_info = fs_root->fs_info;
> +	struct fscrypt_str fname = FSTR_INIT(NULL, 0);
> +	int ret;
> +
> +	/* No encryption, just copy the name in. */
> +	if (!btrfs_fs_incompat(fs_info, ENCRYPT)) {
> +		*bytes_left -= name_len;
> +		if (*bytes_left >= 0)
> +			read_extent_buffer(eb, dest + *bytes_left, name_off, name_len);
> +		return 0;
> +	}
> +
> +	ret = fscrypt_fname_alloc_buffer(BTRFS_NAME_LEN, &fname);
> +	if (ret)
> +		return ret;
> +
> +	ret = btrfs_decrypt_name(fs_root, eb, name_off, name_len, parent, &fname);
> +	if (ret)
> +		goto out;
> +
> +	*bytes_left -= fname.len;
> +	if (*bytes_left >= 0)
> +		memcpy(dest + *bytes_left, fname.name, fname.len);
> +out:
> +	fscrypt_fname_free_buffer(&fname);
> +	return ret;
> +}
> +
>  /*
>   * this iterates to turn a name (from iref/extref) into a full filesystem path.
>   * Elements of the path are separated by '/' and the path is guaranteed to be
> @@ -2138,10 +2172,10 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
>  		dest[bytes_left] = '\0';
>
>  	while (1) {
> -		bytes_left -= name_len;
> -		if (bytes_left >= 0)
> -			read_extent_buffer(eb, dest + bytes_left,
> -					   name_off, name_len);
> +		ret = copy_resolved_iref_to_buf(fs_root, eb, dest, parent,
> +						name_off, name_len, &bytes_left);
> +		if (ret)
> +			break;
>  		if (eb != eb_in) {
>  			if (!path->skip_locking)
>  				btrfs_tree_read_unlock(eb);

Does this code leak the extent buffer when copy_resolved_iref_to_buf()
fails? Looking at the loop structure in btrfs_ref_to_path(), when
copy_resolved_iref_to_buf() returns an error and we break at line 2178,
the cleanup code that follows never executes:

    if (eb != eb_in) {
        if (!path->skip_locking)
            btrfs_tree_read_unlock(eb);
        free_extent_buffer(eb);
    }

This can happen in subsequent iterations where eb != eb_in (the extent
buffer was detached from path->nodes[0] and set to NULL in the previous
iteration). The cleanup at the end of the function (btrfs_release_path()
at line 2216) cannot free eb since it's no longer in the path.

This could be triggered when decryption fails in copy_resolved_iref_to_buf()
due to btrfs_iget() error, fscrypt_fname_alloc_buffer() ENOMEM, or
fscrypt_prepare_readdir() failure on an encrypted filesystem.

Before this patch, the name copy operation (read_extent_buffer) could not
fail, so the cleanup always happened before any error check.


