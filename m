Return-Path: <linux-fscrypt+bounces-1624-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gLAEESZDHmraiAkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1624-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 04:42:46 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D5F1962759C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 04:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 616AA3080C80
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jun 2026 02:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 423B7363C61;
	Tue,  2 Jun 2026 02:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IAHAk0o7"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA872045AD;
	Tue,  2 Jun 2026 02:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780367842; cv=none; b=Gll3aB03ZV8C+x4NbGSsp8GDJWmrj+AnnyalsanSkRk9hW180PSoECWhL2zGnW48hECbrU0Wx19l9V1TtiCy+dW4N4NsmA0gHUtNM42RpsAO0/N/7l2moQFxDBYTmiAW5czzURjvEIM3/71CwuIiX2jhQHacwwVupva5jMUPGh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780367842; c=relaxed/simple;
	bh=kYEzqRitrA1yOZcRXnOHTYIoFHJ7ntpnOgk0O46/yAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=flBotdyyeU7lzycTXx1YOwZxhjI6TNBeRd936b7TdKc/frj54nY3CoWDtxo8OAKfdsjPZs1/qO9VvCLVAG7gitIIqos/5YTqAcze3cYE819iuUi26PmlON/yfAErZYJetDSqgRK8w2urJm5Elek9C9IY1THR1mIO4w7+Mt5JA+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IAHAk0o7; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3471F00893;
	Tue,  2 Jun 2026 02:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780367841;
	bh=iVNDfmYXmNjqWe+oajqOXVvIheRcluHOyyr3Wi9TkJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IAHAk0o7UFWnKz+t+pxY59AorJGaJ95fohs9cvwf39SyYeUqlVZlL64lpgLld9LtL
	 RnoYdbVlxUwLXDZqr+3Z31cQH/dsAqYH00PB5FP0DvtpQPJuQT6gSK8caztWsti23h
	 M0rSvnKmdqAPB0QsDsXrmfKYObaOyTwBuCnmmjMs4BFjytYj31YvICIJeokrnqv4it
	 ylyHNMZu64dMLEunQYFKsj9rI4iEmldJmpxTMDPMB/QZtGmFDd8mBlJkd3NPqGOv4V
	 HALNyfVy+XJBeSZosHdzFAgkSRkgLL37ugMjj3/GxPHXl+YXPwn0CSaubOnPJbxeWS
	 OsBj+lMjECp9g==
Date: Mon, 1 Jun 2026 19:35:56 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Omar Sandoval <osandov@osandov.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH v7 15/43] btrfs: implement fscrypt ioctls
Message-ID: <20260602023556.GC2295@sol>
References: <20260513085340.3673127-1-neelx@suse.com>
 <20260513085340.3673127-16-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085340.3673127-16-neelx@suse.com>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1624-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: D5F1962759C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 13, 2026 at 10:52:49AM +0200, Daniel Vacek wrote:
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 6a37dd3cc5ee..2e0b79f41197 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -5159,6 +5159,35 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_get_fslabel(fs_info, argp);
>  	case FS_IOC_SETFSLABEL:
>  		return btrfs_ioctl_set_fslabel(file, argp);
> +#ifdef CONFIG_BTRFS_EXPERIMENTAL
> +	case FS_IOC_SET_ENCRYPTION_POLICY: {
> +		if (!IS_ENABLED(CONFIG_FS_ENCRYPTION))
> +			return -EOPNOTSUPP;
> +		if (sb_rdonly(fs_info->sb))
> +			return -EROFS;
> +		/*
> +		 *  If we crash before we commit, nothing encrypted could have
> +		 * been written so it doesn't matter whether the encrypted
> +		 * state persists.
> +		 */
> +		btrfs_set_fs_incompat(fs_info, ENCRYPT);
> +		return fscrypt_ioctl_set_policy(file, (const void __user *)arg);
> +	}
> +	case FS_IOC_GET_ENCRYPTION_POLICY:
> +		return fscrypt_ioctl_get_policy(file, (void __user *)arg);
> +	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
> +		return fscrypt_ioctl_get_policy_ex(file, (void __user *)arg);
> +	case FS_IOC_ADD_ENCRYPTION_KEY:
> +		return fscrypt_ioctl_add_key(file, (void __user *)arg);
> +	case FS_IOC_REMOVE_ENCRYPTION_KEY:
> +		return fscrypt_ioctl_remove_key(file, (void __user *)arg);
> +	case FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS:
> +		return fscrypt_ioctl_remove_key_all_users(file, (void __user *)arg);
> +	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
> +		return fscrypt_ioctl_get_key_status(file, (void __user *)arg);
> +	case FS_IOC_GET_ENCRYPTION_NONCE:
> +		return fscrypt_ioctl_get_nonce(file, (void __user *)arg);
> +#endif /* CONFIG_BTRFS_EXPERIMENTAL */

Are you sure you want to auto-enable the "encrypt" feature flag like
this?  It doesn't even require a privilege.

It's also only in FS_IOC_SET_ENCRYPTION_POLICY, so this doesn't work in
cases where users add a key first.

- Eric

