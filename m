Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC9848FE16
	for <lists+linux-fscrypt@lfdr.de>; Sun, 16 Jan 2022 18:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbiAPRBi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jan 2022 12:01:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49250 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230002AbiAPRBi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jan 2022 12:01:38 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20GDvsCg016021;
        Sun, 16 Jan 2022 17:01:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=WVQFrUA3+Cen8gMIctXTembDyH1XWI+Mv1mgAZY5t24=;
 b=W5lIKGej67eyuZJfPZ6o3212xc/NjIiTHe7Hk01Mpci+XEBoAUVQrMYs6h7JPzSxap8T
 85otTHDkD9Nbd1659U0img0ryh4i/GekQGEiyD5ilRSuAXOjSZqXT7KFWGmjtMYhMKnx
 zPG2cMciV7kjNiU9uamb5f1lpc/4hs4uPoGaWij1zRVIQOMkp3/EgZtVmebF/pUuYV81
 dsKnJPbjK8wZ3LQNXm3HBusWtC1bFCkMIZLUArGQTAkE016s7BLEU8iBEdVm4Bun16t5
 JJQ/RUrGENiwo54p3uWs1A6Vkt/cN1HueWWIK7J8yhHuBmYGbwDlyj/J9LGFrqy0+7Mo ZA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dmmq7afd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 16 Jan 2022 17:01:34 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20GGwEwb011646;
        Sun, 16 Jan 2022 17:01:32 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3dknhhxasr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 16 Jan 2022 17:01:32 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20GH1UBL37421534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Jan 2022 17:01:30 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 227AEA405C;
        Sun, 16 Jan 2022 17:01:30 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58B69A405B;
        Sun, 16 Jan 2022 17:01:29 +0000 (GMT)
Received: from sig-9-65-85-26.ibm.com (unknown [9.65.85.26])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 16 Jan 2022 17:01:29 +0000 (GMT)
Message-ID: <bc803a35d914dde65640428d2b29cc6e89d176d4.camel@linux.ibm.com>
Subject: Re: [PATCH v1 4/5] ima: support fs-verity file digest based
 signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Vitaly Chikunov <vt@altlinux.org>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 16 Jan 2022 12:01:28 -0500
In-Reply-To: <YeJn7hxLEfdVrUQT@sol.localdomain>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
         <20211202215507.298415-5-zohar@linux.ibm.com>
         <YalDvGjq0inMFKln@sol.localdomain>
         <56c53b027ae8ae6909d38904bf089e73011657d7.camel@linux.ibm.com>
         <YdYrw4eiQPryOMkZ@gmail.com> <20220109204537.oueokvvkrkyy3ipq@altlinux.org>
         <YdtOhsv/A5dqlApY@sol.localdomain>
         <20220115053101.36xoy2bc7ypozo6l@altlinux.org>
         <YeJn7hxLEfdVrUQT@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gJWl7dFAQzped6KqgG_h6tdwblcBTeT3
X-Proofpoint-ORIG-GUID: gJWl7dFAQzped6KqgG_h6tdwblcBTeT3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-16_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxscore=0 spamscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 phishscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201160112
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 2022-01-14 at 22:21 -0800, Eric Biggers wrote:
> On Sat, Jan 15, 2022 at 08:31:01AM +0300, Vitaly Chikunov wrote:
> > Eric,
> > 
> > On Sun, Jan 09, 2022 at 01:07:18PM -0800, Eric Biggers wrote:
> > > On Sun, Jan 09, 2022 at 11:45:37PM +0300, Vitaly Chikunov wrote:
> > > > On Wed, Jan 05, 2022 at 03:37:39PM -0800, Eric Biggers wrote:
> > > > > On Fri, Dec 31, 2021 at 10:35:00AM -0500, Mimi Zohar wrote:
> > > > > > On Thu, 2021-12-02 at 14:07 -0800, Eric Biggers wrote:
> > > > > > > On Thu, Dec 02, 2021 at 04:55:06PM -0500, Mimi Zohar wrote:
> > > > > > > >  	case IMA_VERITY_DIGSIG:
> > > > > > > > -		fallthrough;
> > > > > > > > +		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> > > > > > > > +
> > > > > > > > +		/*
> > > > > > > > +		 * The IMA signature is based on a hash of IMA_VERITY_DIGSIG
> > > > > > > > +		 * and the fs-verity file digest, not directly on the
> > > > > > > > +		 * fs-verity file digest.  Both digests should probably be
> > > > > > > > +		 * included in the IMA measurement list, but for now this
> > > > > > > > +		 * digest is only used for verifying the IMA signature.
> > > > > > > > +		 */
> > > > > > > > +		verity_digest[0] = IMA_VERITY_DIGSIG;
> > > > > > > > +		memcpy(verity_digest + 1, iint->ima_hash->digest,
> > > > > > > > +		       iint->ima_hash->length);
> > > > > > > > +
> > > > > > > > +		hash.hdr.algo = iint->ima_hash->algo;
> > > > > > > > +		hash.hdr.length = iint->ima_hash->length;
> > > > > > > 
> > > > > > > This is still wrong because the bytes being signed don't include the hash
> > > > > > > algorithm.  Unless you mean for it to be implicitly always SHA-256?  fs-verity
> > > > > > > supports SHA-512 too, and it may support other hash algorithms in the future.
> > > > > > 
> > > > > > IMA assumes that the file hash algorithm and the signature algorithm
> > > > > > are the same.   If they're not the same, for whatever reason, the
> > > > > > signature verification would simply fail.
> > > > > > 
> > > > > > Based on the v2 signature header 'type' field, IMA can differentiate
> > > > > > between regular IMA file hash based signatures and fs-verity file
> > > > > > digest based signatures.  The digest field (d-ng) in the IMA
> > > > > > meausrement list prefixes the digest with the hash algorithm. I'm
> > > > > > missing the reason for needing to hash fs-verity's file digest with
> > > > > > other metadata, and sign that hash rather than fs-verity's file digest
> > > > > > directly.
> > > > > 
> > > > > Because if someone signs a raw hash, then they also implicitly sign the same
> > > > > hash value for all supported hash algorithms that produce the same length hash.
> > > > 
> > > > Unless there is broken hash algorithm allowing for preimage attacks this
> > > > is irrelevant. If there is two broken algorithms allowing for collisions,
> > > > colliding hashes could be prepared even if algo id is hashed too.
> > > > 
> > > 
> > > Only one algorithm needs to be broken.  For example, SM3 has the same hash
> > > length as SHA-256.  If SM3 support were to be added to fs-verity, and if someone
> > > were to find a way to find an input that has a specific SM3 digest, then they
> > > could also make it match a specific SHA-256 digest.  Someone might intend to
> > > sign a SHA-256 digest, but if they are only signing the raw 32 bytes of the
> > > digest, then they would also be signing the corresponding SM3 digest.  That's
> > > why the digest that is signed *must* also include the algorithm used in the
> > > digest (not the algorithm(s) used in the signature, which is different).
> > 
> > I think it will be beneficial if we pass hash algo id to the
> > akcipher_alg::verify. In fact, ecrdsa should only be used with streebog.
> > And perhaps, sm2 with sm3, pkcs1 with md/sha/sm3, and ecdsa with sha family
> > hashes.
> > 
> 
> I was going to reply to this thread again, but I got a bit distracted by
> everything else being broken.  Yes, the kernel needs to be restricting which
> hash algorithms can be used with each public key algorithm, along the lines of
> what you said.  I asked the BoringSSL maintainers for advice, and they confirmed
> that ECDSA just signs/verifies a raw hash, and in fact it *must* be a raw hash
> for it to be secure.  This is a design flaw in ECDSA, which was fixed in newer
> algorithms such as EdDSA and SM2 as those have a hash built-in to the signature
> scheme.  To mitigate it, the allowed hash algorithms must be restricted; in the
> case of ECDSA, that means to the SHA family (preferably excluding SHA-1).
> 
> akcipher_alg::verify doesn't actually know which hash algorithm is used, except
> in the case of rsa-pkcs1pad where it is built into the name of the algorithm.
> So it can't check the hash algorithm.  I believe it needs to happen in
> public_key_verify_signature() (and I'm working on a patch for that).
> 
> Now, SM2 is different from ECDSA and ECRDSA in that it uses the modern design
> that includes the hash into the signature algorithm.  This means that it must be
> used to sign/verify *data*, not a hash.  (Well, you can sign/verify a hash, but
> SM2 will hash it again internally.)  Currently, public_key_verify_signature()
> allows SM2 to be used to sign/verify a hash, skipping the SM2 internal hash, and
> IMA uses this.  This is broken and must be removed, since it isn't actually the
> SM2 algorithm as specified anymore, but rather some homebrew thing with unknown
> security properties. (Well, I'm not confident about SM2, but homebrew is worse.)
> 
> Adding fs-verity support to IMA also complicates things, as doing it naively
> would introduce an ambiguity about what is signed.  Naively, the *data* that is
> signed (considering the hash as part of the signature algorithm) would be either
> the whole file, in the case of traditional IMA, or the fsverity_descriptor
> struct, in the case of IMA with fs-verity.  However, a file could have contents
> which match an fsverity_descriptor struct; that would create an ambiguity.
> 
> Assuming that it needs to be allowed that the same key can sign files for both
> traditional and fs-verity hashing, solving this problem will require a second
> hash.

The IMA fs-verity policy rule could require specifying the hash
algorithm.  If it would require specifying a particular key as well,
would hashing the hash then not be needed?

> The easiest way to do this would be sign/verify the following struct:
> 	struct ima_file_id {
> 		u8 is_fsverity;
> 		u8 hash_algorithm;
> 		u8 hash[];
> 	};
> 

The v2 version of this patch introduces the "ima_tbs_hash" structure,
which is more generic, since it uses the IMA xattr record type.  Other
than that, I don't see a difference.

> This would be the *data* that is signed/verified -- meaning that it would be
> hashed again as part of the signature algorithm (whether that hash is built-in
> to the signature algorithm, as is the case for modern algorithms, or handled by
> the caller as is the case for legacy algorithms).

There seems to be an inconsistency, here, with what you said above,
"... ECDSA just signs/verifies a raw hash, and in fact it *must* be a
raw hash for it to be secure."

> Note that both traditional
> and fs-verity hashes would need to use this same method for it to be secure; the
> kernel must not accept signatures using the old method at the same time.

The v2 version of this patch set signed the hash of a hash just for fs-
verity signatures.  Adding the equivalent support for regular file
hashes will require the version in the IMA signature_v2_hdr to be
incremented.  If the version is incremented now, both signatures
versions should then be able to co-exist.

thanks,

Mimi

