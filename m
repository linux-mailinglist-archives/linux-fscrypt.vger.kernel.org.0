Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313AE1B2C48
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Apr 2020 18:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgDUQQP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 21 Apr 2020 12:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729203AbgDUQQN (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 21 Apr 2020 12:16:13 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18FB4206E9;
        Tue, 21 Apr 2020 16:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587485773;
        bh=qiXf63zWTCGvTjnG70KB7NRulvFM0OVVL4QXB3MGXmc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nKDhbbd9U21xz25oia5puKhBJCJQbDmVNbR62oq2SH72dJBmUP6HzF2jOjOPGxcUf
         QpdCdyfhPdcFJ6HVni4y/N5AXhcgDfGJd1F6GgWMVjj1ENDBgad80jv4C2kTBB23Me
         cUNc0R4ZZRuwkEZ6jj83pGmM4+1Yn7Bk21FFW1Nk=
Date:   Tue, 21 Apr 2020 09:16:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jsorensen@fb.com>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 3/9] Move fsverity_descriptor definition to libfsverity.h
Message-ID: <20200421161611.GA95716@gmail.com>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
 <20200312214758.343212-4-Jes.Sorensen@gmail.com>
 <20200322045722.GC111151@sol.localdomain>
 <ebca4865-60e7-c61e-b335-c2962482643b@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebca4865-60e7-c61e-b335-c2962482643b@fb.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Apr 21, 2020 at 12:07:07PM -0400, Jes Sorensen wrote:
> On 3/22/20 12:57 AM, Eric Biggers wrote:
> > On Thu, Mar 12, 2020 at 05:47:52PM -0400, Jes Sorensen wrote:
> >> From: Jes Sorensen <jsorensen@fb.com>
> >>
> >> Signed-off-by: Jes Sorensen <jsorensen@fb.com>
> >> ---
> >>  cmd_sign.c    | 19 +------------------
> >>  libfsverity.h | 26 +++++++++++++++++++++++++-
> >>  2 files changed, 26 insertions(+), 19 deletions(-)
> >>
> >> diff --git a/cmd_sign.c b/cmd_sign.c
> >> index dcc44f8..1792084 100644
> >> --- a/cmd_sign.c
> >> +++ b/cmd_sign.c
> >> @@ -20,26 +20,9 @@
> >>  #include <unistd.h>
> >>  
> >>  #include "commands.h"
> >> -#include "fsverity_uapi.h"
> >> +#include "libfsverity.h"
> >>  #include "hash_algs.h"
> >>  
> >> -/*
> >> - * Merkle tree properties.  The file measurement is the hash of this structure
> >> - * excluding the signature and with the sig_size field set to 0.
> >> - */
> >> -struct fsverity_descriptor {
> >> -	__u8 version;		/* must be 1 */
> >> -	__u8 hash_algorithm;	/* Merkle tree hash algorithm */
> >> -	__u8 log_blocksize;	/* log2 of size of data and tree blocks */
> >> -	__u8 salt_size;		/* size of salt in bytes; 0 if none */
> >> -	__le32 sig_size;	/* size of signature in bytes; 0 if none */
> >> -	__le64 data_size;	/* size of file the Merkle tree is built over */
> >> -	__u8 root_hash[64];	/* Merkle tree root hash */
> >> -	__u8 salt[32];		/* salt prepended to each hashed block */
> >> -	__u8 __reserved[144];	/* must be 0's */
> >> -	__u8 signature[];	/* optional PKCS#7 signature */
> >> -};
> >> -
> >>  /*
> >>   * Format in which verity file measurements are signed.  This is the same as
> >>   * 'struct fsverity_digest', except here some magic bytes are prepended to
> >> diff --git a/libfsverity.h b/libfsverity.h
> >> index ceebae1..396a6ee 100644
> >> --- a/libfsverity.h
> >> +++ b/libfsverity.h
> >> @@ -13,13 +13,14 @@
> >>  
> >>  #include <stddef.h>
> >>  #include <stdint.h>
> >> +#include <linux/types.h>
> >>  
> >>  #define FS_VERITY_HASH_ALG_SHA256       1
> >>  #define FS_VERITY_HASH_ALG_SHA512       2
> >>  
> >>  struct libfsverity_merkle_tree_params {
> >>  	uint16_t version;
> >> -	uint16_t hash_algorithm;
> >> +	uint16_t hash_algorithm;	/* Matches the digest_algorithm type */
> >>  	uint32_t block_size;
> >>  	uint32_t salt_size;
> >>  	const uint8_t *salt;
> >> @@ -27,6 +28,7 @@ struct libfsverity_merkle_tree_params {
> >>  };
> >>  
> >>  struct libfsverity_digest {
> >> +	char magic[8];			/* must be "FSVerity" */
> >>  	uint16_t digest_algorithm;
> >>  	uint16_t digest_size;
> >>  	uint8_t digest[];
> >> @@ -38,4 +40,26 @@ struct libfsverity_signature_params {
> >>  	uint64_t reserved[11];
> >>  };
> >>  
> >> +/*
> >> + * Merkle tree properties.  The file measurement is the hash of this structure
> >> + * excluding the signature and with the sig_size field set to 0.
> >> + */
> >> +struct fsverity_descriptor {
> >> +	uint8_t version;	/* must be 1 */
> >> +	uint8_t hash_algorithm;	/* Merkle tree hash algorithm */
> >> +	uint8_t log_blocksize;	/* log2 of size of data and tree blocks */
> >> +	uint8_t salt_size;	/* size of salt in bytes; 0 if none */
> >> +	__le32 sig_size;	/* size of signature in bytes; 0 if none */
> >> +	__le64 data_size;	/* size of file the Merkle tree is built over */
> >> +	uint8_t root_hash[64];	/* Merkle tree root hash */
> >> +	uint8_t salt[32];	/* salt prepended to each hashed block */
> >> +	uint8_t __reserved[144];/* must be 0's */
> >> +	uint8_t signature[];	/* optional PKCS#7 signature */
> >> +};
> >> +
> > 
> > I thought there was no need for this to be part of the library API?
> 
> Hi Eric,
> 
> Been busy working on RPM support, but looking at this again now. Given
> that the fsverity signature is a hash of the descriptor, I don't see how
> we can avoid this?
> 

struct fsverity_descriptor isn't signed directly; it's hashed as an intermediate
step in libfsverity_compute_digest().  So why would the library user need the
definition of 'struct fsverity_descriptor'?

- Eric
