Return-Path: <linux-fscrypt+bounces-1124-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OFx5FQQ3hmmHLAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1124-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:46:28 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D52102352
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:46:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BA491304000C
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63652423A99;
	Fri,  6 Feb 2026 18:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ghSgZxc3"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF1F334389;
	Fri,  6 Feb 2026 18:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770403412; cv=none; b=AnxmxNfPFvwE6IFnUxnElItwAFMrKQ9w/6e3lqqGlmEhDwXy4RgWVmyYFQF5nRCQniExny7cVZfrXo8zNmxNiU9yBM7mD5lwqV5vmzQWQgE0UJ2sddZS1rM3n7GYphulPTAiVe27Gf4O5Cy0RICN0Chx2csFtu7P2sIs1avySN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770403412; c=relaxed/simple;
	bh=m2u3aS6qyIKpZ+B5yYweZY5yt2FWLknmxlOhLyDMYlo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SXRwQSewyoHuYUrS13j9lue2BOUNkVK+l/hWsOo3b1fsN2jeZ3zPj623azbDza7kS9t0EYB3e7Gvnb3krlVIIoPQ/yqhc4NmDqfBVrh8BcA+yM6g94xPhnZHoothmBX81ciGbzqsd+EY4YsiQm9WXxxn6sJQOo9XsnH3zwxKICU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ghSgZxc3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=5QgLdcZSJhE8gvGsOPWe5bcX4FmYEvLxJG2bZjeJSzs=; b=ghSgZxc3NDfOm/juowJcnVFjJb
	8ejnGmmUATCsJHB4+E/wg4Rx9oyw7ZQifZ0GGNgxT5qce6NZ7Z9oXZ2A1CBhUPRGUagdBdBYn+P0k
	mGqVItf+BPVrmcn7p5CL3WwfH6gbB7UfBxteyZCiGze0Pl+AYX5qeNQpyFq07PIdDVvOb76UDR064
	3rbbbOqyByC4JrrD3DeRY3hRMaKjpuBdNEovV2e92RgHtIhpA1TfYI8qPJHReax9fuH/6D3xcq5sE
	LLqZN895XViPjiAUgi1YOR36Dz0gOrrzwKaMeEcYUBbXQeP6pkPND6vNQIJmZj9NNmrECrtu8thjX
	dIKSkYCQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1voQne-0000000Bhm7-3NB0;
	Fri, 06 Feb 2026 18:43:26 +0000
Message-ID: <64126c50-063e-40e4-a536-233cce94b65e@infradead.org>
Date: Fri, 6 Feb 2026 10:43:24 -0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/43] fscrypt: add documentation about extent
 encryption
To: Daniel Vacek <neelx@suse.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, Eric Biggers <ebiggers@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20260206182336.1397715-1-neelx@suse.com>
 <20260206182336.1397715-9-neelx@suse.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260206182336.1397715-9-neelx@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1124-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[infradead.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rdunlap@infradead.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,toxicpanda.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C2D52102352
X-Rspamd-Action: no action



On 2/6/26 10:22 AM, Daniel Vacek wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Add a couple of sections to the fscrypt documentation about per-extent
> encryption.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> ---
> 
> v5: https://lore.kernel.org/linux-btrfs/7b2cc4dd423c3930e51b1ef5dd209164ff11c05a.1706116485.git.josef@toxicpanda.com/
>  * No changes since.
> ---
>  Documentation/filesystems/fscrypt.rst | 41 +++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 70af896822e1..8afec55dd913 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -283,6 +283,21 @@ alternative master keys or to support rotating master keys.  Instead,
>  the master keys may be wrapped in userspace, e.g. as is done by the
>  `fscrypt <https://github.com/google/fscrypt>`_ tool.
>  
> +Per-extent encryption keys
> +--------------------------
> +
> +For certain file systems, such as btrfs, it's desired to derive a
> +per-extent encryption key.  This is to enable features such as snapshots
> +and reflink, where you could have different inodes pointing at the same
> +extent.  When a new extent is created fscrypt randomly generates a
> +16-byte nonce and the file system stores it along side the extent.

                                               alongside

> +Then, it uses a KDF (as described in `Key derivation function`_) to
> +derive the extent's key from the master key and nonce.
> +
> +Currently the inode's master key and encryption policy must match the
> +extent, so you cannot share extents between inodes that were encrypted
> +differently.
> +
>  DIRECT_KEY policies
>  -------------------
>  
> @@ -1488,6 +1503,27 @@ by the kernel and is used as KDF input or as a tweak to cause
>  different files to be encrypted differently; see `Per-file encryption
>  keys`_ and `DIRECT_KEY policies`_.
>  
> +Extent encryption context
> +-------------------------
> +
> +The extent encryption context mirrors the important parts of the above
> +`Encryption context`_, with a few ommisions.  The struct is defined as

                                     omissions

> +follows::
> +
> +        struct fscrypt_extent_context {
> +                u8 version;
> +                u8 encryption_mode;
> +                u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
> +                u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
> +        };
> +
> +Currently all fields much match the containing inode's encryption
> +context, with the exception of the nonce.
> +
> +Additionally extent encryption is only supported with
> +FSCRYPT_EXTENT_CONTEXT_V2 using the standard policy, all other policies

                                                policy; all other policies

> +are disallowed.
> +
>  Data path changes
>  -----------------
>  
> @@ -1511,6 +1547,11 @@ buffer.  Some filesystems, such as UBIFS, already use temporary
>  buffers regardless of encryption.  Other filesystems, such as ext4 and
>  F2FS, have to allocate bounce pages specially for encryption.
>  
> +Inline encryption is not optional for extent encryption based file
> +systems, the amount of objects required to be kept around is too much.

   systems; the amount of

> +Inline encryption handles the object lifetime details which results in a
> +cleaner implementation.
> +
>  Filename hashing and encoding
>  -----------------------------
>  

-- 
~Randy


