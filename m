Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1A9493200
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Jan 2022 01:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349603AbiASAtE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Jan 2022 19:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349367AbiASAtE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Jan 2022 19:49:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4A2C061574;
        Tue, 18 Jan 2022 16:49:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4755B61484;
        Wed, 19 Jan 2022 00:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BA9C340E0;
        Wed, 19 Jan 2022 00:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642553342;
        bh=fAebEo9D2w4bZ3VevQjkt0fPkJdGlFkA2aCUDz7lyzE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KjtRmqcHOKAuOt9I80FDebonvaFOaJrngWuTTScP+XNnNAotws3lH0U/gampjxUWF
         q3M5Q482tOyHvMnAKeYLquNNBBfV9V5GNgOempIa1JDK5uW8CNQuEkp5LP1+X5/HJs
         zWZKm6YTaQ9yICaLwJLz4JatnvO+oF1j6r1QdfDe/4dFrY9+Npf0e0l4f25XNEqPAR
         yUiurRYwR1IMqdZk5rzRYTn+a+5B115rq7nR+XoP+X8UCC2iPF4CaMhQV2f+rgZ33s
         iq4VUIxzmaQMIrjDmLGqKxhSm/7br54bnZP/8tmw4tgfsiEFfM/wlGFTZt0YRk8mJ/
         UlI74ewK9GNZg==
Date:   Tue, 18 Jan 2022 16:49:01 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stefan Berger <stefanb@linux.ibm.com>
Cc:     Vitaly Chikunov <vt@altlinux.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 4/5] ima: support fs-verity file digest based
 signatures
Message-ID: <Yedf/VyOsTha++b8@sol.localdomain>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
 <20211202215507.298415-5-zohar@linux.ibm.com>
 <YalDvGjq0inMFKln@sol.localdomain>
 <56c53b027ae8ae6909d38904bf089e73011657d7.camel@linux.ibm.com>
 <YdYrw4eiQPryOMkZ@gmail.com>
 <20220109204537.oueokvvkrkyy3ipq@altlinux.org>
 <YdtOhsv/A5dqlApY@sol.localdomain>
 <20220115053101.36xoy2bc7ypozo6l@altlinux.org>
 <YeJn7hxLEfdVrUQT@sol.localdomain>
 <7e611504-eed8-6943-f1ae-7fb23298d3e5@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7e611504-eed8-6943-f1ae-7fb23298d3e5@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Jan 15, 2022 at 10:31:40PM -0500, Stefan Berger wrote:
> 
> On 1/15/22 01:21, Eric Biggers wrote:
> > On Sat, Jan 15, 2022 at 08:31:01AM +0300, Vitaly Chikunov wrote:
> > > Eric,
> > > 
> > > On Sun, Jan 09, 2022 at 01:07:18PM -0800, Eric Biggers wrote:
> > > > On Sun, Jan 09, 2022 at 11:45:37PM +0300, Vitaly Chikunov wrote:
> > > > > On Wed, Jan 05, 2022 at 03:37:39PM -0800, Eric Biggers wrote:
> > > > > > On Fri, Dec 31, 2021 at 10:35:00AM -0500, Mimi Zohar wrote:
> > > > > > > On Thu, 2021-12-02 at 14:07 -0800, Eric Biggers wrote:
> > > > > > > > On Thu, Dec 02, 2021 at 04:55:06PM -0500, Mimi Zohar wrote:
> > > > > > > > >   	case IMA_VERITY_DIGSIG:
> > > > > > > > > -		fallthrough;
> > > > > > > > > +		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> > > > > > > > > +
> > > > > > > > > +		/*
> > > > > > > > > +		 * The IMA signature is based on a hash of IMA_VERITY_DIGSIG
> > > > > > > > > +		 * and the fs-verity file digest, not directly on the
> > > > > > > > > +		 * fs-verity file digest.  Both digests should probably be
> > > > > > > > > +		 * included in the IMA measurement list, but for now this
> > > > > > > > > +		 * digest is only used for verifying the IMA signature.
> > > > > > > > > +		 */
> > > > > > > > > +		verity_digest[0] = IMA_VERITY_DIGSIG;
> > > > > > > > > +		memcpy(verity_digest + 1, iint->ima_hash->digest,
> > > > > > > > > +		       iint->ima_hash->length);
> > > > > > > > > +
> > > > > > > > > +		hash.hdr.algo = iint->ima_hash->algo;
> > > > > > > > > +		hash.hdr.length = iint->ima_hash->length;
> > > > > > > > This is still wrong because the bytes being signed don't include the hash
> > > > > > > > algorithm.  Unless you mean for it to be implicitly always SHA-256?  fs-verity
> > > > > > > > supports SHA-512 too, and it may support other hash algorithms in the future.
> > > > > > > IMA assumes that the file hash algorithm and the signature algorithm
> > > > > > > are the same.   If they're not the same, for whatever reason, the
> > > > > > > signature verification would simply fail.
> > > > > > > 
> > > > > > > Based on the v2 signature header 'type' field, IMA can differentiate
> > > > > > > between regular IMA file hash based signatures and fs-verity file
> > > > > > > digest based signatures.  The digest field (d-ng) in the IMA
> > > > > > > meausrement list prefixes the digest with the hash algorithm. I'm
> > > > > > > missing the reason for needing to hash fs-verity's file digest with
> > > > > > > other metadata, and sign that hash rather than fs-verity's file digest
> > > > > > > directly.
> > > > > > Because if someone signs a raw hash, then they also implicitly sign the same
> > > > > > hash value for all supported hash algorithms that produce the same length hash.
> > > > > Unless there is broken hash algorithm allowing for preimage attacks this
> > > > > is irrelevant. If there is two broken algorithms allowing for collisions,
> > > > > colliding hashes could be prepared even if algo id is hashed too.
> > > > > 
> > > > Only one algorithm needs to be broken.  For example, SM3 has the same hash
> > > > length as SHA-256.  If SM3 support were to be added to fs-verity, and if someone
> > > > were to find a way to find an input that has a specific SM3 digest, then they
> > > > could also make it match a specific SHA-256 digest.  Someone might intend to
> > > > sign a SHA-256 digest, but if they are only signing the raw 32 bytes of the
> > > > digest, then they would also be signing the corresponding SM3 digest.  That's
> > > > why the digest that is signed *must* also include the algorithm used in the
> > > > digest (not the algorithm(s) used in the signature, which is different).
> > > I think it will be beneficial if we pass hash algo id to the
> > > akcipher_alg::verify. In fact, ecrdsa should only be used with streebog.
> > > And perhaps, sm2 with sm3, pkcs1 with md/sha/sm3, and ecdsa with sha family
> > > hashes.
> > > 
> > I was going to reply to this thread again, but I got a bit distracted by
> > everything else being broken.  Yes, the kernel needs to be restricting which
> > hash algorithms can be used with each public key algorithm, along the lines of
> > what you said.  I asked the BoringSSL maintainers for advice, and they confirmed
> > that ECDSA just signs/verifies a raw hash, and in fact it *must* be a raw hash
> > for it to be secure.  This is a design flaw in ECDSA, which was fixed in newer
> > algorithms such as EdDSA and SM2 as those have a hash built-in to the signature
> > scheme.  To mitigate it, the allowed hash algorithms must be restricted; in the
> > case of ECDSA, that means to the SHA family (preferably excluding SHA-1).
> > 
> > akcipher_alg::verify doesn't actually know which hash algorithm is used, except
> > in the case of rsa-pkcs1pad where it is built into the name of the algorithm.
> > So it can't check the hash algorithm.  I believe it needs to happen in
> > public_key_verify_signature() (and I'm working on a patch for that).
> > 
> > Now, SM2 is different from ECDSA and ECRDSA in that it uses the modern design
> > that includes the hash into the signature algorithm.  This means that it must be
> > used to sign/verify *data*, not a hash.  (Well, you can sign/verify a hash, but
> > SM2 will hash it again internally.)  Currently, public_key_verify_signature()
> > allows SM2 to be used to sign/verify a hash, skipping the SM2 internal hash, and
> > IMA uses this.  This is broken and must be removed, since it isn't actually the
> > SM2 algorithm as specified anymore, but rather some homebrew thing with unknown
> > security properties. (Well, I'm not confident about SM2, but homebrew is worse.)
> > 
> > Adding fs-verity support to IMA also complicates things, as doing it naively
> > would introduce an ambiguity about what is signed.  Naively, the *data* that is
> > signed (considering the hash as part of the signature algorithm) would be either
> > the whole file, in the case of traditional IMA, or the fsverity_descriptor
> > struct, in the case of IMA with fs-verity.  However, a file could have contents
> > which match an fsverity_descriptor struct; that would create an ambiguity.
> > 
> > Assuming that it needs to be allowed that the same key can sign files for both
> > traditional and fs-verity hashing, solving this problem will require a second
> > hash.  The easiest way to do this would be sign/verify the following struct:
> > 
> > 	struct ima_file_id {
> > 		u8 is_fsverity;
> > 		u8 hash_algorithm;
> > 		u8 hash[];
> > 	};
> 
> 
> To calrify, I suppose that for ECDSA NIST P256 you would allow pairing with
> any of the SHA family hashes (also as defined by the existing OIDs) and as
> the standard allows today? And the same then applies for NIST p384 etc.?
> 
> Further, I suppose similar restriction would apply for ECRDSA to pair it
> with Streebog only, as Vitaly said.

I don't have any better ideas.

> What's happening now is that to verify a signature, IMA/integrity subsystem
> fills out the following structure:
> 
> struct public_key_signature pks;
> 
> pks.hash_algo = hash_algo_name[hdr->hash_algo];  // name of hash algo will
> go into this here, e.g., 'sha256'
> pks.pkey_algo = pk->pkey_algo; // this is either 'rsa', 'ecdsa-', 'ecrdsa-'
> or 'sm2' string
> 
> It then calls:
> 
>     ret = verify_signature(key, &pks);
> 
> IMO, in the call path down this function the pairing of public key and hash
> algo would have to be enforced in order to enforce the standards. Would this
> not be sufficient to be able to stay with the standards ?

That sounds right, though there are a number of other issues including SM2 being
implemented incorrectly, the "encoding" string isn't validated, and it not being
enforced that public_key_signature::pkey_algo actually matches
public_key::pkey_algo.

> File hashes: IMA calculates the hash over a file itself by calling crypto
> functions, so at least the digest's bytes are trusted input in that respect
> and using the sha family type of hashes directly with ECDSA should work.
> Which algorithm IMA is supposed to use for the hashing is given in the xattr
> bytestream header. IMA could then take that type of hash, lookup the hash
> function, perform the hashing on the data, and let verify_signature enforce
> the pairing, rejecting file signatures with wrong pairing. This way the only
> thing that is needed is 'enforcement of pairing'.
> 
> Fsverity: How much control does a user have over the hash family fsverity is
> using? Can IMA ECDSA/RSA users tell it to use a sha family hash and ECRDSA
> users make it use a Streebog hash so that also the pairing of hash and key
> type can work 'naturally' and we don't need the level of indirection via
> your structure above?

The hash algorithm used by fs-verity is configurable and is always returned
along with the file digest.  Currently, only SHA-256 and SHA-512 are supported.

Keep in mind that if you sign the fs-verity file digest directly with RSA,
ECDSA, or ECRDSA, the *data* you are actually signing is the fsverity_descriptor
-- the struct which the hash is a hash of.

That creates an ambiguity when full file hashes are also signed by the same key,
as I previously mentioned.  A level of indirection is needed to avoid that.

In the naive method, the *data* being signed would also be different with SM2.
The level of indirection would avoid that.

- Eric
