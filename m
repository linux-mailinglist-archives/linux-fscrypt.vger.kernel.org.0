Return-Path: <linux-fscrypt+bounces-180-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13AD784C196
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Feb 2024 01:57:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44B541C21B83
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Feb 2024 00:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 121A28F70;
	Wed,  7 Feb 2024 00:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U0bYrvWR"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB1A8F5B;
	Wed,  7 Feb 2024 00:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707267454; cv=none; b=IhybWOB4EdkHMVgCknQL/uTx+YkxAp5nruqbJywqn8Ip92w3Opig3e8BdRA45tf5ftvgziYVuY8YrKh3Nk2fDkBH/A7Kv9SY8oxM0LUkpfFta5I9X0PCxz1Qu5h9DRNhj+NtD9b8G6wDI+wIe2WYw1pXFzz2OtvlIzuCOo5OfN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707267454; c=relaxed/simple;
	bh=lL3mKiCws6pWFAMFjTg6ily/dhXqJah1X10c4YGqtrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ucaEPSBy1RZmwWL6g9itrrtIMCir4LiWREry/1nPVyFRmSJDslRFjsSZzz2CHxqfnZWrb0Pukf33x7dHcbm/QHKb6eHZ2IwRQcFuc0PBS6ghJPTVkmNd2lpiwueNJNAE+8ta7wTXtRwp3VTUSLN+zt9x4LZwROsdufaWjWFOJvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U0bYrvWR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109CFC433C7;
	Wed,  7 Feb 2024 00:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707267453;
	bh=lL3mKiCws6pWFAMFjTg6ily/dhXqJah1X10c4YGqtrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U0bYrvWREl+8qQBiKQa3MQenrozJ8Un7op+4HAo3mnuSfyIxPJbHH5lwacMKhFFuV
	 MMzOjJdC/TWntNWk1SHxLmQlJX76ZbQA/dHx52E9WWKQf4eNXSa/q8zS66A6KNU5LT
	 I+boMoiDoHLFDO7X6mQSy3F+iLwWEBGI3H1HUj6MFvNybVferAZ7C7fdeUZK1frq7n
	 JW9gMy7dvMhHGy2wBrTWFg9QtvZH+qITaY8hIX1eCRfq0wrMFzCTxmy8idjBK4SOYt
	 71FHNcdpu5xIZLc40CQ1B/pBVkMEsoQOffF4hoD51VHGpgXKuUElBfs14LNBRFFQRl
	 pnnjz8rJxTgGg==
Date: Tue, 6 Feb 2024 16:57:31 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Luis Henriques <lhenriques@suse.de>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: clear keyring before calling key_put()
Message-ID: <20240207005731.GB35324@sol.localdomain>
References: <20240206101619.8083-1-lhenriques@suse.de>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240206101619.8083-1-lhenriques@suse.de>

On Tue, Feb 06, 2024 at 10:16:19AM +0000, Luis Henriques wrote:
> Now that the key quotas are handled immediately on key_put() instead of
> being postponed to the key management garbage collection worker, a call to
> keyring_clear() is all that is required in fscrypt_put_master_key() so that
> the keyring clean-up is also done synchronously.  This patch should fix the
> fstest generic/581 flakiness.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
> Hi!
> 
> I know that patch "keys: update key quotas in key_put()" isn't yet merged
> but since David and Jarkko seem to be OK with it, it doesn't hurt to send
> this follow-up patch immediately.
> 
> Cheers,
> -- 
> Luis
> 
>  fs/crypto/keyring.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
> index 0edf0b58daa7..dfdaae16b83a 100644
> --- a/fs/crypto/keyring.c
> +++ b/fs/crypto/keyring.c
> @@ -74,8 +74,11 @@ void fscrypt_put_master_key(struct fscrypt_master_key *mk)
>  	 * that concurrent keyring lookups can no longer find it.
>  	 */
>  	WARN_ON_ONCE(refcount_read(&mk->mk_active_refs) != 0);
> -	key_put(mk->mk_users);
> -	mk->mk_users = NULL;
> +	if (mk->mk_users) {
> +		keyring_clear(mk->mk_users);
> +		key_put(mk->mk_users);
> +		mk->mk_users = NULL;
> +	}
>  	call_rcu(&mk->mk_rcu_head, fscrypt_free_master_key);

Applied, thanks.  I added a comment above the call to keyring_clear() to explain
why it's there:

        /* Clear the keyring so the quota gets released right away. */

- Eric

