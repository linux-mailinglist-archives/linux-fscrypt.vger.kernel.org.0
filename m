Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250C62BB44B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 Nov 2020 20:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730350AbgKTStf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 20 Nov 2020 13:49:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729800AbgKTStf (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 20 Nov 2020 13:49:35 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A3662242B;
        Fri, 20 Nov 2020 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605898174;
        bh=Ol1V+awsZyShvCLrIsyrRkGBuRBH+qkCbl7XsdSlcFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1VKHBBzuW4zruQo2TgG699JZYdIwW3reEUuEr6z9lVwFMgFR/Bmo6pqrZMUqPK6eN
         hykUyyeHU6R7oTXMoUHjToBcOIDWEkgBva81y7xv5fXROyzHRfrgpQI32gcUdeMv6g
         quXAfwYB0r6u6WMRoRCKgR0ZZk3oBoTjnjdRm7kM=
Date:   Fri, 20 Nov 2020 10:49:31 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: Re: [PATCH v2] block/keyslot-manager: prevent crash when num_slots=1
Message-ID: <X7gPu4RdTfXnxkYk@sol.localdomain>
References: <20201111214855.428044-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111214855.428044-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 11, 2020 at 01:48:55PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> If there is only one keyslot, then blk_ksm_init() computes
> slot_hashtable_size=1 and log_slot_ht_size=0.  This causes
> blk_ksm_find_keyslot() to crash later because it uses
> hash_ptr(key, log_slot_ht_size) to find the hash bucket containing the
> key, and hash_ptr() doesn't support the bits == 0 case.
> 
> Fix this by making the hash table always have at least 2 buckets.
> 
> Tested by running:
> 
>     kvm-xfstests -c ext4 -g encrypt -m inlinecrypt \
>                  -o blk-crypto-fallback.num_keyslots=1
> 
> Fixes: 1b2628397058 ("block: Keyslot Manager for Inline Encryption")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  block/keyslot-manager.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/block/keyslot-manager.c b/block/keyslot-manager.c
> index 35abcb1ec051d..86f8195d8039e 100644
> --- a/block/keyslot-manager.c
> +++ b/block/keyslot-manager.c
> @@ -103,6 +103,13 @@ int blk_ksm_init(struct blk_keyslot_manager *ksm, unsigned int num_slots)
>  	spin_lock_init(&ksm->idle_slots_lock);
>  
>  	slot_hashtable_size = roundup_pow_of_two(num_slots);
> +	/*
> +	 * hash_ptr() assumes bits != 0, so ensure the hash table has at least 2
> +	 * buckets.  This only makes a difference when there is only 1 keyslot.
> +	 */
> +	if (slot_hashtable_size < 2)
> +		slot_hashtable_size = 2;
> +
>  	ksm->log_slot_ht_size = ilog2(slot_hashtable_size);
>  	ksm->slot_hashtable = kvmalloc_array(slot_hashtable_size,
>  					     sizeof(ksm->slot_hashtable[0]),
> 

Ping?
