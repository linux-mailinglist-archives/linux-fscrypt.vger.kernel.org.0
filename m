Return-Path: <linux-fscrypt+bounces-1630-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KMmtJBtPHmrmiQkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1630-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 05:33:47 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A1B6E627CFB
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 05:33:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7D133300E32C
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jun 2026 03:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 880D233B6FB;
	Tue,  2 Jun 2026 03:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSacz+0N"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652123672B1;
	Tue,  2 Jun 2026 03:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780370915; cv=none; b=dK2M/zib4yMIe9bXusuzHEaiuvBJ1kZrhCXCktjVYqd0oDd0KA29Bm2b3nd1JcOnBYO5TtibbNdtnjBT1TBl2LlE7qalJjQO8ffvWZfbSi/CktGg1Re3/uhIbpfmmA1mwlp10hfw+XKK9mQ+lN8740wmtMn4AL23JzsEkk8zkoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780370915; c=relaxed/simple;
	bh=NKFuBn+dShcm/VIC4I0y884SQpNh6C38L1ZKw0P8kco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ehzSmygM3aakiY6ESIOvnT9mGYj1XCDID8CsbC+tEnv6O3ugml0s/3fAgrGwRKH+g9oCpIo3FaQeVIkh4eiB/vIK8CITlTLtTcMsSVMphvNS0H7SwfDLk26SgjEvozgKD4Vl8zSEyh5Gp0TVDeQJJbItUEUQazt+EGKjalZEv0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSacz+0N; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05B41F00898;
	Tue,  2 Jun 2026 03:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780370914;
	bh=QzmYCSnyFJkG6KCO3M7XHLzRbzo9hRl374pQDpED/oU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BSacz+0NMKk2h6FKutbbCag/D4pi1wuxfW9zktdrVitLKHSSuejRbG/fRv1YVedP4
	 Jo99eGCZPTiqicH+xNkoXxOKQNTwL3hu6laKu5B2wIeumOwHnUfEeISVnaurVENiVn
	 cM4KVX46CM0lNr0TSpJKA363C45rMN+8llLllfJ6A6OyfMc5AFXmBkOSYhUTgVzlbC
	 tE9raXJNXdNfCXGhUoZxBh2G6qzSzZZZ92T/t3+WIlcM6DfgiSPmEepWbPF3QOqhi3
	 M3orsNoiNEnWz67WKFnhnGPwxvukd817PE5k4b7CzFmA+bsQyddqNjtrR+2SemNPc1
	 DZFjWMxsq02aw==
Date: Mon, 1 Jun 2026 20:27:10 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Omar Sandoval <osandov@osandov.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH v7 12/43] btrfs: add new FEATURE_INCOMPAT_ENCRYPT flag
Message-ID: <20260602032710.GI2295@sol>
References: <20260513085340.3673127-1-neelx@suse.com>
 <20260513085340.3673127-13-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085340.3673127-13-neelx@suse.com>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1630-lists,linux-fscrypt=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,suse.com:email,dorminy.me:email,osandov.com:email,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Queue-Id: A1B6E627CFB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 13, 2026 at 10:52:46AM +0200, Daniel Vacek wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> As encrypted files will be incompatible with older filesystem versions,
> new filesystems should be created with an incompat flag for fscrypt,
> which will gate access to the encryption ioctls.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> ---
> 
> v5: https://lore.kernel.org/linux-btrfs/ccbea52046c1dadbbef926bfc878cc23af952729.1706116485.git.josef@toxicpanda.com/
>  * No changes since.
> ---
>  fs/btrfs/fs.h              | 3 ++-
>  fs/btrfs/super.c           | 5 +++++
>  fs/btrfs/sysfs.c           | 6 ++++++
>  include/uapi/linux/btrfs.h | 1 +
>  4 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index a4758d94b32e..dbdb73722c14 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -322,7 +322,8 @@ enum {
>  	(BTRFS_FEATURE_INCOMPAT_SUPP_STABLE |	\
>  	 BTRFS_FEATURE_INCOMPAT_RAID_STRIPE_TREE | \
>  	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2 | \
> -	 BTRFS_FEATURE_INCOMPAT_REMAP_TREE)
> +	 BTRFS_FEATURE_INCOMPAT_REMAP_TREE |	\
> +	 BTRFS_FEATURE_INCOMPAT_ENCRYPT)
>  
>  #else
>  
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index efaa0788c1fc..84df97363611 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2563,6 +2563,11 @@ static int __init btrfs_print_mod_info(void)
>  			", fsverity=yes"
>  #else
>  			", fsverity=no"
> +#endif
> +#ifdef CONFIG_FS_ENCRYPTION
> +			", fscrypt=yes"
> +#else
> +			", fscrypt=no"
>  #endif
>  			;
>  
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 0d14570c8bc2..3fe57843f902 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -305,6 +305,9 @@ BTRFS_FEAT_ATTR_INCOMPAT(remap_tree, REMAP_TREE);
>  #ifdef CONFIG_FS_VERITY
>  BTRFS_FEAT_ATTR_COMPAT_RO(verity, VERITY);
>  #endif
> +#ifdef CONFIG_FS_ENCRYPTION
> +BTRFS_FEAT_ATTR_INCOMPAT(encryption, ENCRYPT);
> +#endif /* CONFIG_FS_ENCRYPTION */
>  
>  /*
>   * Features which depend on feature bits and may differ between each fs.
> @@ -338,6 +341,9 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
>  #ifdef CONFIG_FS_VERITY
>  	BTRFS_FEAT_ATTR_PTR(verity),
>  #endif
> +#ifdef CONFIG_FS_ENCRYPTION
> +	BTRFS_FEAT_ATTR_PTR(encryption),
> +#endif /* CONFIG_FS_ENCRYPTION */
>  	NULL
>  };
>  
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 9165154a274d..2f6a46e5f4ce 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -335,6 +335,7 @@ struct btrfs_ioctl_fs_info_args {
>  #define BTRFS_FEATURE_INCOMPAT_ZONED		(1ULL << 12)
>  #define BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2	(1ULL << 13)
>  #define BTRFS_FEATURE_INCOMPAT_RAID_STRIPE_TREE	(1ULL << 14)
> +#define BTRFS_FEATURE_INCOMPAT_ENCRYPT		(1ULL << 15)
>  #define BTRFS_FEATURE_INCOMPAT_SIMPLE_QUOTA	(1ULL << 16)
>  #define BTRFS_FEATURE_INCOMPAT_REMAP_TREE	(1ULL << 17)

There seems to be an inconsistency where btrfs's fscrypt support depends
on CONFIG_BTRFS_EXPERIMENTAL, but the support is advertised in sysfs
regardless.

- Eric

