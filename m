Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FA548A644
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jan 2022 04:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbiAKD0c (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Jan 2022 22:26:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41062 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235613AbiAKD0a (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Jan 2022 22:26:30 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20B03WFj011713;
        Tue, 11 Jan 2022 03:26:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=7Zec0JE8DSYyZ3+x0Cj4jr0I1PGrbY9iX3XHxPtxMjE=;
 b=hO+CmRtPAaefmPziacAWNGRZh2u996OUspzsl1p9Hz0TakAs5TOtad6LsFU/VXz0gHeT
 iM2QnlXe/ie/LL0tJXJL9dkXc/BNyZjNjk+QTjtgu747dq3oo9GGcecQBKOh/4J552bt
 TSNFXUeCnPIJWneCWN8Zf+6kkGMYNabvWKMa2QaHYViy7PNCdFNH7KdPXUmy9PjYUaTv
 lI0bUsse3wnWtgJa0GGYotodUfOJLnnWHEQaq+oVNk4C21vcl/zgUuWcvO5wqcz8gXdT
 uZNQwfLI2TWvRj6lNVfXDu364Xo7AP8G9n5GEEUViJfODVvymV+ijSZF+lgKT9LmDc5d cQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfm2y1v4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 03:26:26 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20B3CACg016146;
        Tue, 11 Jan 2022 03:26:25 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3df28a51hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 03:26:25 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20B3QOl635258670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 03:26:24 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 957366E05B;
        Tue, 11 Jan 2022 03:26:24 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 419266E050;
        Tue, 11 Jan 2022 03:26:24 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 03:26:24 +0000 (GMT)
Message-ID: <b4105f9b-98f7-f941-47db-2f72e0c5b8bd@linux.ibm.com>
Date:   Mon, 10 Jan 2022 22:26:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 5/6] ima: support fs-verity file digest based
 signatures
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220109185517.312280-1-zohar@linux.ibm.com>
 <20220109185517.312280-6-zohar@linux.ibm.com> <Ydy3EA9ONY3kn1xr@gmail.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <Ydy3EA9ONY3kn1xr@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RQotlfO7C_oy4H4go4oMY9Bl5wkF36Az
X-Proofpoint-ORIG-GUID: RQotlfO7C_oy4H4go4oMY9Bl5wkF36Az
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_01,2022-01-10_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110008
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 1/10/22 17:45, Eric Biggers wrote:
> On Sun, Jan 09, 2022 at 01:55:16PM -0500, Mimi Zohar wrote:
>> +	case IMA_VERITY_DIGSIG:
>> +		set_bit(IMA_DIGSIG, &iint->atomic_flags);
>> +
>> +		algo = iint->ima_hash->algo;
>> +		hash = kzalloc(sizeof(*hash) + hash_digest_size[algo],
>> +			       GFP_KERNEL);
>> +		if (!hash) {
>> +			*cause = "verity-hashing-error";
>> +			*status = INTEGRITY_FAIL;
>> +			break;
>> +		}
>> +
>> +		rc = calc_tbs_hash(IMA_VERITY_DIGSIG, iint->ima_hash->algo,
>> +				   iint->ima_hash->digest, hash);
>> +		if (rc) {
>> +			*cause = "verity-hashing-error";
>> +			*status = INTEGRITY_FAIL;
>> +			break;
>> +		}
>> +
>> +		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
>> +					     (const char *)xattr_value,
>> +					     xattr_len, hash->digest,
>> +					     hash->length);
> This is still verifying a raw hash value, which is wrong as I've explained
> several times.  Yes, you are now hashing the hash algorithm ID together with the
> original hash value, but at the end the thing being signed/verified is still a
> raw hash value, which is ambigious.
>
> I think I see where the confusion is.  If rsa-pkcs1pad is used, then the
> asymmetric algorithm is parameterized by a hash algorithm, and this hash
> algorithm's identifier is automatically built-in to the data which is
> signed/verified.  And the data being signed/verified is assumed to be a hash
> value of the same type.  So in this case, the caller doesn't need to handle
> disambiguating raw hashes.
>
> However, asymmetric_verify() also supports ecdsa and ecrdsa signatures.  As far
> as I can tell, those do *not* have the hash algorithm identifier built-in to the
> data which is signed/verified; they just sign/verify the data given.  That


The signatures are generated by evmctl by this code here, which works 
for RSA and ECDSA and likely also ECRDSA:

https://sourceforge.net/p/linux-ima/ima-evm-utils/ci/master/tree/src/libimaevm.c#l1036

    if (!EVP_PKEY_sign_init(ctx))
         goto err;
     st = "EVP_get_digestbyname";
     if (!(md = EVP_get_digestbyname(algo)))
         goto err;
     st = "EVP_PKEY_CTX_set_signature_md";
     if (!EVP_PKEY_CTX_set_signature_md(ctx, md))
         goto err;
     st = "EVP_PKEY_sign";
     sigsize = MAX_SIGNATURE_SIZE - sizeof(struct signature_v2_hdr) - 1;
     if (!EVP_PKEY_sign(ctx, hdr->sig, &sigsize, hash, size))
         goto err;
     len = (int)sigsize;

As far as I know, these are not raw signatures but generate the OIDs for 
RSA + shaXYZ or ECDSA + shaXYZ (1.2.840.10045.4.1 et al) and prepend 
them to the hash and then sign that.


> creates an ambiguity if the hash algorithm identifier is not included.  For
> example, someone might have intended to sign the SHA-256 hash
> 01ba4719c80b6fe911b091a7c05124b64eeece964e09c058ef8f9805daca546b.  However, the
> Streebog or SM3 hash
> 01ba4719c80b6fe911b091a7c05124b64eeece964e09c058ef8f9805daca546b would also pass
> the signature check too.  That's wrong; to have a valid cryptosystem, you
> mustn't let the adversary choose the crypto algorithms for you.

There's a hash algorithm identifier in the xattr in the header, which is 
prepended to the bytes of the actual signature. This hash algo identifer 
tells IMA which hash to use on the file data so that subsequent 
signature verification with the same hash works. That same hash 
identifier is then again embedded in the signature using the OID and 
thus has to match on the signature verification level.

The effectively double hashed data via calc_tbs_hash() above is not 
good. calc_tbs_hash() is unnecessary.

On the evmctl level the signature should be created from the digest 
retrieved via ioctl() [or similar I suppose] from fsverity on the file 
and fsverity presumably then also says what type of hash this is. So, 
fsverity ioctl response of hash + size of hash and hash_algo become 
input to the evmctl snippet above. On the kernel level the data from 
fsverity_get_digest() should be all it takes to verify against an xattr 
created by evmctl as described.


>
> I'm not sure how this can be reconciled, given the differences between
> rsa-pkcs1pad and ecdsa and ecrdsa.  Could you just use the lowest common
> denominator and prepend the hash algorithm ID to the hash value, or would that
> cause issues with rsa-pkcs1pad?  In any case, to move forward you're going to
> need to solve this problem.
>
> - Eric
