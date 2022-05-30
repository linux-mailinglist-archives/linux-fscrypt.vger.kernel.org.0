Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883D853872B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 30 May 2022 20:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240336AbiE3SRw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 30 May 2022 14:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239547AbiE3SRv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 30 May 2022 14:17:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342BE57116;
        Mon, 30 May 2022 11:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3BF96077B;
        Mon, 30 May 2022 18:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174A1C385B8;
        Mon, 30 May 2022 18:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653934669;
        bh=f6IbMLWwvc3aq8BpnOkh1PinEQC0U7w5dKhB9js57e0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s0roayvVeFO0XoZ4fnhoAAotsTRUAwCIEzlZsSsT7y35H7h/LCgzd9Z+QzRoFaJbZ
         nFcwqyweaOIfP8zqWpFvsmfdhz6jergWfgL4GCa+JYS6wP0MnF2daqc7wSvi2j3yOD
         cg/HsmQ1gB4OmjJrNUcnUoM5P9ncry+zoHfxhZUf2V6BVvAKD75nrDEssf00bb4+83
         lGkI1nHsuoQqX493H9ZWxad8S0QG9UZwyG0kMvtsTK2ZMWsUPPGhsTxCJwBRyb0iwE
         ukXYpgeQjFYhqTm4n1rMOS+bgslgLsuySpj/BGBn+dqV++qzRSv00AJPw2F1D83VyZ
         NntjIyDEwbIVg==
Date:   Mon, 30 May 2022 11:17:47 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     fstests@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        linux-fscrypt@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/2] fscrypt-crypt-util: add HCTR2 reference
 implementation
Message-ID: <YpUKS8vti5d0ucU6@sol.localdomain>
References: <20220520182315.615327-1-nhuck@google.com>
 <20220520182315.615327-2-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520182315.615327-2-nhuck@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Please include the linux-fscrypt mailing list in Cc.

On Fri, May 20, 2022 at 01:23:14PM -0500, Nathan Huckleberry wrote:
> This patch adds a reference implementation of HCTR2 to the fscrypt
> testing utility.

The reference implementation is at https://github.com/google/hctr2.
This one is just an "implementation", not a "reference implementation".

>  /* Multiply a GF(2^128) element by the polynomial 'x' */
> -static inline void gf2_128_mul_x(ble128 *t)
> +static inline void gf2_128_mul_x_ble(ble128 *t)
>  {
>  	u64 lo = le64_to_cpu(t->lo);
>  	u64 hi = le64_to_cpu(t->hi);
> @@ -302,6 +356,38 @@ static inline void gf2_128_mul_x(ble128 *t)
>  	t->lo = cpu_to_le64((lo << 1) ^ ((hi & (1ULL << 63)) ? 0x87 : 0));
>  }
>  
> +static inline void gf2_128_mul_x_polyval(ble128 *t)
> +{

Please adjust the naming and comments to clearly distinguish between
gf2_128_mul_x_ble() and gf2_128_mul_x_polyval().  The intention of the original
code was that "ble" gave the field convention used.  However, the XTS and
POLYVAL field conventions both use "ble" but differ in the reduction polynomial.
So "ble" is no longer unambiguous.  How about renaming gf2_128_mul_x_ble() to
gf2_128_mul_x_xts() to indicate it is using the XTS convention?

> +	u64 lo = le64_to_cpu(t->lo);
> +	u64 hi = le64_to_cpu(t->hi);
> +
> +	u64 lo_reducer = ((hi >> 63) & 1ULL) ? 1 : 0;
> +	u64 hi_reducer = ((hi >> 63) & 1ULL) ? 0xc2ULL << 56 : 0;

There shouldn't be a newline between variable declarations.

Also maybe write '(hi & (1ULL << 63))', so the code is more easily comparable to
gf2_128_mul_x_xts().

> +void gf2_128_mul_polyval(ble128 *r, const ble128 *b)
> +{
> +	ble128 p;
> +	u64 lo = le64_to_cpu(b->lo);
> +	u64 hi = le64_to_cpu(b->hi);
> +
> +	memset(&p, 0, sizeof(p));
> +	for (int i = 0; i < 64; i++) {

'i' should be declared at the beginning.

> +		if (lo & (1ULL << i))
> +			xor((u8 *)&p, (u8 *)&p, (u8 *)r, sizeof(p));
> +		gf2_128_mul_x_polyval(r);
> +	}
> +	for (int i = 0; i < 64; i++) {
> +		if (hi & (1ULL << i))
> +			xor((u8 *)&p, (u8 *)&p, (u8 *)r, sizeof(p));
> +		gf2_128_mul_x_polyval(r);
> +	}
> +	memcpy(r, &p, sizeof(p));
> +}

The last line can be '*r = p;'

> +
>  /*----------------------------------------------------------------------------*
>   *                             Group arithmetic                               *
>   *----------------------------------------------------------------------------*/
> @@ -901,6 +987,41 @@ static void test_hkdf_sha512(void)
>  }
>  #endif /* ENABLE_ALG_TESTS */
>  
> +/*----------------------------------------------------------------------------*
> + *                                 POLYVAL                                     *
> + *----------------------------------------------------------------------------*/
> +
> +#define POLYVAL_KEY_SIZE	16
> +#define POLYVAL_BLOCK_SIZE	16
> +
> +static void polyval_update(const u8 key[POLYVAL_KEY_SIZE],
> +			   const u8 *msg, size_t msglen,
> +			   u8 accumulator[POLYVAL_BLOCK_SIZE])
> +{
> +	ble128 h;
> +	// x^{-128} = x^127 + x^124 + x^121 + x^114 + 1
> +	static const ble128 inv128 = {
> +	    cpu_to_le64(1),
> +	    cpu_to_le64(0x9204ULL << 48)
> +	};

Use tabs for indentation, please.  This applies elsewhere in the file too.

> +	int nblocks = msglen / POLYVAL_BLOCK_SIZE;

size_t

> +	int tail = msglen % POLYVAL_BLOCK_SIZE;
> +
> +	memcpy(&h, key, sizeof(h));
> +	gf2_128_mul_polyval(&h, &inv128);
> +
> +	while (nblocks > 0) {
> +		xor(accumulator, accumulator, msg, POLYVAL_BLOCK_SIZE);
> +		gf2_128_mul_polyval((ble128 *)accumulator, &h);

Casting a byte array to ble128, and then dereferencing it, is undefined
behavior since it increases the alignment that is assumed.

> +#define HCTR2_IV_SIZE 32
> +static void aes_256_hctr2_crypt(const u8 key[AES_256_KEY_SIZE],
> +				const u8 iv[HCTR2_IV_SIZE], const u8 *src,
> +				u8 *dst, size_t nbytes, bool decrypting)
> +{
> +	struct aes_key k;
> +	u8 hbar[AES_BLOCK_SIZE] = {0};
> +	u8 L[AES_BLOCK_SIZE] = {1};
> +	size_t bulk_bytes = nbytes - AES_BLOCK_SIZE;
> +	size_t remainder = bulk_bytes % AES_BLOCK_SIZE;
> +	le128 tweaklen_blk = {
> +	    .lo = cpu_to_le64(HCTR2_IV_SIZE * 8 * 2 + 2 + (remainder != 0))
> +	};
> +	u8 padded_block[POLYVAL_BLOCK_SIZE];
> +	u8 digest[POLYVAL_BLOCK_SIZE];
> +	const u8 *M = src;
> +	const u8 *N = src + AES_BLOCK_SIZE;
> +	u8 MM[AES_BLOCK_SIZE];
> +	u8 UU[AES_BLOCK_SIZE];
> +	u8 S[AES_BLOCK_SIZE];
> +	u8 *U = dst;
> +	u8 *V = dst + AES_BLOCK_SIZE;
> +
> +	ASSERT(nbytes >= AES_BLOCK_SIZE);
> +	aes_setkey(&k, key, AES_256_KEY_SIZE);
> +
> +	aes_encrypt(&k, hbar, hbar);
> +	aes_encrypt(&k, L, L);
> +
> +	memset(digest, 0, POLYVAL_BLOCK_SIZE);
> +	polyval_update(hbar, (u8 *)&tweaklen_blk, POLYVAL_BLOCK_SIZE, digest);
> +	polyval_update(hbar, iv, HCTR2_IV_SIZE, digest);
> +
> +	polyval_update(hbar, N, bulk_bytes - remainder, digest);
> +	if (remainder) {
> +		memset(padded_block, 0, POLYVAL_BLOCK_SIZE);
> +		memcpy(padded_block, N + bulk_bytes - remainder, remainder);
> +		padded_block[remainder] = 0x01;
> +		polyval_update(hbar, padded_block, POLYVAL_BLOCK_SIZE, digest);
> +	}
> +
> +	xor(MM, M, digest, AES_BLOCK_SIZE);
> +
> +	if (decrypting)
> +		aes_decrypt(&k, MM, UU);
> +	else
> +		aes_encrypt(&k, MM, UU);
> +
> +	xor(S, MM, UU, AES_BLOCK_SIZE);
> +	xor(S, L, S, AES_BLOCK_SIZE);
> +
> +	aes_256_xctr_crypt(key, S, N, V, bulk_bytes);
> +
> +	memset(digest, 0, POLYVAL_BLOCK_SIZE);
> +	polyval_update(hbar, (u8 *)&tweaklen_blk, POLYVAL_BLOCK_SIZE, digest);
> +	polyval_update(hbar, iv, HCTR2_IV_SIZE, digest);
> +
> +	polyval_update(hbar, V, bulk_bytes - remainder, digest);
> +	if (remainder) {
> +		memset(padded_block, 0, POLYVAL_BLOCK_SIZE);
> +		memcpy(padded_block, V + bulk_bytes - remainder, remainder);
> +		padded_block[remainder] = 0x01;
> +		polyval_update(hbar, padded_block, POLYVAL_BLOCK_SIZE, digest);
> +	}
> +
> +	xor(U, UU, digest, AES_BLOCK_SIZE);
> +}

Long functions with many local variables are hard to read.  This would be easier
to read if it used some helper functions, each called twice:

static void hctr2_hash_iv(const u8 hbar[POLYVAL_KEY_SIZE],
			  const u8 iv[HCTR2_IV_SIZE], size_t msglen,
			  u8 digest[POLYVAL_BLOCK_SIZE])
{
	le128 tweaklen_blk = {
		.lo = cpu_to_le64(HCTR2_IV_SIZE * 8 * 2 + 2 +
				  (msglen % AES_BLOCK_SIZE != 0))
	};

	memset(digest, 0, POLYVAL_BLOCK_SIZE);
	polyval_update(hbar, (u8 *)&tweaklen_blk, POLYVAL_BLOCK_SIZE, digest);
	polyval_update(hbar, iv, HCTR2_IV_SIZE, digest);
}

static void hctr2_hash_message(const u8 hbar[POLYVAL_KEY_SIZE],
			       const u8 *msg, size_t msglen,
			       u8 digest[POLYVAL_BLOCK_SIZE])
{
	size_t remainder = msglen % AES_BLOCK_SIZE;
	u8 padded_block[POLYVAL_BLOCK_SIZE] = {0};

	polyval_update(hbar, msg, msglen - remainder, digest);
	if (remainder) {
		memcpy(padded_block, &msg[msglen - remainder], remainder);
		padded_block[remainder] = 1;
		polyval_update(hbar, padded_block, POLYVAL_BLOCK_SIZE, digest);
	}
}

> +		rand_bytes(key, sizeof(key));
> +		rand_bytes(iv, sizeof(iv));
> +		rand_bytes(ptext, datalen);
> +		memset(key, 0, sizeof(key));
> +		memset(iv, 0, sizeof(iv));
> +		memset(ptext, 0, datalen);

What's going on here?  The memset() calls shouldn't be there.

- Eric
