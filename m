Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC77F48FA79
	for <lists+linux-fscrypt@lfdr.de>; Sun, 16 Jan 2022 04:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbiAPDcV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 15 Jan 2022 22:32:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22304 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232790AbiAPDcV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 15 Jan 2022 22:32:21 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20G1wP2t028211;
        Sun, 16 Jan 2022 03:32:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=A9mOB1Iw3sYUpOmfgZ5VDnbmpJWdRQdjyXXt3/CMPPg=;
 b=ojwK09aPOCZV/ID+cdcIvwvcvrHmQYFVULI19kOnW91EDf17c+0xhDVnRNDXhrTHgfUU
 +jrvHbAh3hWG7MmnN1cqWlRt9YvT9F8mhNr6Sy6v4ORNRM2MGxc21rxQbbx31j0P8cqk
 EyLvZbFHEEbsjQ7Q8Zh50P3kl0aRqzcmzEnW4FGhFEJyFNFPdkaBAJ0oxIaCYaddRMKf
 wcQlileU1aI2e21HbxgREjGkXYkva24LC0F425YaX4EaDR5lDFxTg1mJ8rPQhh8wRzDU
 jhq/e+PiqwWDHNOu8AWpPhbzBoCU2VCiG49hso/STYfOJj81VLm8oN+3xY44XJLQn2ru og== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dma5m8vpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 16 Jan 2022 03:32:16 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20G3VnEO001417;
        Sun, 16 Jan 2022 03:32:15 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 3dknw8jjqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 16 Jan 2022 03:32:15 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20G3WFwe34865584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Jan 2022 03:32:15 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 051A2B2065;
        Sun, 16 Jan 2022 03:32:15 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E80F4B2067;
        Sun, 16 Jan 2022 03:32:14 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 16 Jan 2022 03:32:14 +0000 (GMT)
Message-ID: <7e611504-eed8-6943-f1ae-7fb23298d3e5@linux.ibm.com>
Date:   Sat, 15 Jan 2022 22:31:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v1 4/5] ima: support fs-verity file digest based
 signatures
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>,
        Vitaly Chikunov <vt@altlinux.org>
Cc:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211202215507.298415-1-zohar@linux.ibm.com>
 <20211202215507.298415-5-zohar@linux.ibm.com>
 <YalDvGjq0inMFKln@sol.localdomain>
 <56c53b027ae8ae6909d38904bf089e73011657d7.camel@linux.ibm.com>
 <YdYrw4eiQPryOMkZ@gmail.com> <20220109204537.oueokvvkrkyy3ipq@altlinux.org>
 <YdtOhsv/A5dqlApY@sol.localdomain>
 <20220115053101.36xoy2bc7ypozo6l@altlinux.org>
 <YeJn7hxLEfdVrUQT@sol.localdomain>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <YeJn7hxLEfdVrUQT@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P4xjsozF8ITxkV656M1Poek7gY14MUlZ
X-Proofpoint-ORIG-GUID: P4xjsozF8ITxkV656M1Poek7gY14MUlZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-16_01,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 phishscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201160023
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 1/15/22 01:21, Eric Biggers wrote:
> On Sat, Jan 15, 2022 at 08:31:01AM +0300, Vitaly Chikunov wrote:
>> Eric,
>>
>> On Sun, Jan 09, 2022 at 01:07:18PM -0800, Eric Biggers wrote:
>>> On Sun, Jan 09, 2022 at 11:45:37PM +0300, Vitaly Chikunov wrote:
>>>> On Wed, Jan 05, 2022 at 03:37:39PM -0800, Eric Biggers wrote:
>>>>> On Fri, Dec 31, 2021 at 10:35:00AM -0500, Mimi Zohar wrote:
>>>>>> On Thu, 2021-12-02 at 14:07 -0800, Eric Biggers wrote:
>>>>>>> On Thu, Dec 02, 2021 at 04:55:06PM -0500, Mimi Zohar wrote:
>>>>>>>>   	case IMA_VERITY_DIGSIG:
>>>>>>>> -		fallthrough;
>>>>>>>> +		set_bit(IMA_DIGSIG, &iint->atomic_flags);
>>>>>>>> +
>>>>>>>> +		/*
>>>>>>>> +		 * The IMA signature is based on a hash of IMA_VERITY_DIGSIG
>>>>>>>> +		 * and the fs-verity file digest, not directly on the
>>>>>>>> +		 * fs-verity file digest.  Both digests should probably be
>>>>>>>> +		 * included in the IMA measurement list, but for now this
>>>>>>>> +		 * digest is only used for verifying the IMA signature.
>>>>>>>> +		 */
>>>>>>>> +		verity_digest[0] = IMA_VERITY_DIGSIG;
>>>>>>>> +		memcpy(verity_digest + 1, iint->ima_hash->digest,
>>>>>>>> +		       iint->ima_hash->length);
>>>>>>>> +
>>>>>>>> +		hash.hdr.algo = iint->ima_hash->algo;
>>>>>>>> +		hash.hdr.length = iint->ima_hash->length;
>>>>>>> This is still wrong because the bytes being signed don't include the hash
>>>>>>> algorithm.  Unless you mean for it to be implicitly always SHA-256?  fs-verity
>>>>>>> supports SHA-512 too, and it may support other hash algorithms in the future.
>>>>>> IMA assumes that the file hash algorithm and the signature algorithm
>>>>>> are the same.   If they're not the same, for whatever reason, the
>>>>>> signature verification would simply fail.
>>>>>>
>>>>>> Based on the v2 signature header 'type' field, IMA can differentiate
>>>>>> between regular IMA file hash based signatures and fs-verity file
>>>>>> digest based signatures.  The digest field (d-ng) in the IMA
>>>>>> meausrement list prefixes the digest with the hash algorithm. I'm
>>>>>> missing the reason for needing to hash fs-verity's file digest with
>>>>>> other metadata, and sign that hash rather than fs-verity's file digest
>>>>>> directly.
>>>>> Because if someone signs a raw hash, then they also implicitly sign the same
>>>>> hash value for all supported hash algorithms that produce the same length hash.
>>>> Unless there is broken hash algorithm allowing for preimage attacks this
>>>> is irrelevant. If there is two broken algorithms allowing for collisions,
>>>> colliding hashes could be prepared even if algo id is hashed too.
>>>>
>>> Only one algorithm needs to be broken.  For example, SM3 has the same hash
>>> length as SHA-256.  If SM3 support were to be added to fs-verity, and if someone
>>> were to find a way to find an input that has a specific SM3 digest, then they
>>> could also make it match a specific SHA-256 digest.  Someone might intend to
>>> sign a SHA-256 digest, but if they are only signing the raw 32 bytes of the
>>> digest, then they would also be signing the corresponding SM3 digest.  That's
>>> why the digest that is signed *must* also include the algorithm used in the
>>> digest (not the algorithm(s) used in the signature, which is different).
>> I think it will be beneficial if we pass hash algo id to the
>> akcipher_alg::verify. In fact, ecrdsa should only be used with streebog.
>> And perhaps, sm2 with sm3, pkcs1 with md/sha/sm3, and ecdsa with sha family
>> hashes.
>>
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
> hash.  The easiest way to do this would be sign/verify the following struct:
>
> 	struct ima_file_id {
> 		u8 is_fsverity;
> 		u8 hash_algorithm;
> 		u8 hash[];
> 	};


To calrify, I suppose that for ECDSA NIST P256 you would allow pairing 
with any of the SHA family hashes (also as defined by the existing OIDs) 
and as the standard allows today? And the same then applies for NIST 
p384 etc.?

Further, I suppose similar restriction would apply for ECRDSA to pair it 
with Streebog only, as Vitaly said.


What's happening now is that to verify a signature, IMA/integrity 
subsystem fills out the following structure:

struct public_key_signature pks;

pks.hash_algo = hash_algo_name[hdr->hash_algo];  // name of hash algo 
will go into this here, e.g., 'sha256'
pks.pkey_algo = pk->pkey_algo; // this is either 'rsa', 'ecdsa-', 
'ecrdsa-' or 'sm2' string

It then calls:

     ret = verify_signature(key, &pks);

IMO, in the call path down this function the pairing of public key and 
hash algo would have to be enforced in order to enforce the standards. 
Would this not be sufficient to be able to stay with the standards ?

File hashes: IMA calculates the hash over a file itself by calling 
crypto functions, so at least the digest's bytes are trusted input in 
that respect and using the sha family type of hashes directly with ECDSA 
should work. Which algorithm IMA is supposed to use for the hashing is 
given in the xattr bytestream header. IMA could then take that type of 
hash, lookup the hash function, perform the hashing on the data, and let 
verify_signature enforce the pairing, rejecting file signatures with 
wrong pairing. This way the only thing that is needed is 'enforcement of 
pairing'.

Fsverity: How much control does a user have over the hash family 
fsverity is using? Can IMA ECDSA/RSA users tell it to use a sha family 
hash and ECRDSA users make it use a Streebog hash so that also the 
pairing of hash and key type can work 'naturally' and we don't need the 
level of indirection via your structure above?

     Stefan



> This would be the *data* that is signed/verified -- meaning that it would be
> hashed again as part of the signature algorithm (whether that hash is built-in
> to the signature algorithm, as is the case for modern algorithms, or handled by
> the caller as is the case for legacy algorithms).  Note that both traditional
> and fs-verity hashes would need to use this same method for it to be secure; the
> kernel must not accept signatures using the old method at the same time.
>
> - Eric
