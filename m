Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E4C4A4F6E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 31 Jan 2022 20:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376435AbiAaT3b (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 31 Jan 2022 14:29:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22286 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359797AbiAaT3a (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 31 Jan 2022 14:29:30 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VJ8KFm031008;
        Mon, 31 Jan 2022 19:29:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=eTHKILtqYrrol2f3JyyXhq1FZeMe7iDGs6GmI5xFzeI=;
 b=Rer44v0BCkMB76SFD/8YreZYzCpxlzmvKSGjgvM3ZvpgcDhHqx8FkfZGKQS07lTBN2mB
 7V7OyYVN6Yl0fmo73jyhoR9EUKFgUAlYStVCDlhE81Duj9BJKDa4gCAVDq+k0U7OzbRJ
 H12DGSIuRbk39MCGTiF0chNtXW9mV0Kx9g4R7PFRYcbwpizb1s2s899cLHTvBA4bPZFT
 TJ3hGU1D2ZI2xs511MnNRIO9M7p7/IV2Eb3XvxrFDDcmbGrIOgOyaW69oHqwL6cbOzN3
 ROvb7b4UybOJwvhUgWqSBw9OF8lF53o3/zA8cVs7bg8FblxKTtPjsZJ7Zpmq/QJ3BssF Vg== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dxm8dtmha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 19:29:22 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20VJNeLm026957;
        Mon, 31 Jan 2022 19:29:21 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 3dvw772ebp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 19:29:21 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20VJTJZj36241910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 19:29:19 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6BEF124070;
        Mon, 31 Jan 2022 19:29:19 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7978612405C;
        Mon, 31 Jan 2022 19:29:19 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Jan 2022 19:29:19 +0000 (GMT)
Message-ID: <b262cb06-37fd-9760-8f6e-1dcacbf738b4@linux.ibm.com>
Date:   Mon, 31 Jan 2022 14:29:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [RFC][PATCH v3a 00/11] ima: support fs-verity digests and
 signatures (alternative)
Content-Language: en-US
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220127184614.2837938-1-roberto.sassu@huawei.com>
 <YfLz8NftvbZtKvLT@sol.localdomain> <YfL0+q/ekv4H8lZg@sol.localdomain>
 <d122893c426f44aa95d5168773b60b9d@huawei.com>
 <YfRRUBZpQv2Hi1sL@sol.localdomain>
 <9af14af14beb46a28f57559e4b1dc1a7@huawei.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <9af14af14beb46a28f57559e4b1dc1a7@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jWYRH8SeTkdFK8Ntzt88BaBl_WvQ2Wqm
X-Proofpoint-GUID: jWYRH8SeTkdFK8Ntzt88BaBl_WvQ2Wqm
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_07,2022-01-31_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310124
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 1/31/22 10:12, Roberto Sassu wrote:
>> From: Eric Biggers [mailto:ebiggers@kernel.org]
>> Sent: Friday, January 28, 2022 9:26 PM
>> On Fri, Jan 28, 2022 at 09:05:01AM +0000, Roberto Sassu wrote:
>>>> From: Eric Biggers [mailto:ebiggers@kernel.org]
>>>> Sent: Thursday, January 27, 2022 8:40 PM
>>>> On Thu, Jan 27, 2022 at 11:35:12AM -0800, Eric Biggers wrote:
>>>>> On Thu, Jan 27, 2022 at 07:46:09PM +0100, Roberto Sassu wrote:
>>>>>> I wanted to propose a different approach for handling fsverity digests
>> and
>>>>>> signatures, compared to:
>>>>>>
>>>>>> https://lore.kernel.org/linux-integrity/20220126000658.138345-1-
>>>> zohar@linux.ibm.com/
>>>>>> In the original proposal, a new signature version has been introduced (v3)
>>>>>> to allow the possibility of signing the digest of a more flexible data
>>>>>> structure, ima_file_id, which could also include the fsverity file digest.
>>>>>>
>>>>>> While the new signature type would be sufficient to handle fsverity file
>>>>>> digests, the problem is that its format would not be compatible with the
>>>>>> signature format supported by the built-in verification module in fsverity.
>>>>>> The rpm package manager already has an extension to include fsverity
>>>>>> signatures, with the existing format, in the RPM header.
>>>>>>
>>>>>> Given that the fsverity signature is in the PKCS#7 format, IMA has already
>>>>>> the capability of handling it with the existing code, more specifically the
>>>>>> modsig code. It would be sufficient to provide to modsig the correct data
>>>>>> to avoid introducing a new signature format.
>>>>> I think it would be best to get people moved off of the fs-verity built-in
>>>>> signatures, rather than further extend the use of it.  PKCS#7 is a pretty
>>>>> terrible signature format.  The IMA one is better, though it's unfortunate
>> that
>>>>> IMA still relies on X.509 for keys.
>>>> Note, the only reason that support for fs-verity built-in signatures was added
>>>> to RPM is that people didn't want to use IMA:
>>>> https://lore.kernel.org/linux-fscrypt/b49b4367-51e7-f62a-6209-
>>>> b46a6880824b@gmail.com
>>>>
>>>> If people are going to use IMA anyway, then there would be no point.
>>> Hi Eric
>>>
>>> I thought that the solution I came with could satisfy multiple needs.
>>>
>>> For people that don't want to use IMA, they could still continue
>>> to use the existing signature format, and wait for an LSM that
>>> satisfy their needs. They also have the option to migrate to the
>>> new signature format you are defining. But will those people be
>>> willing to switch to something IMA-specific?
>>>
>>> For people that use IMA, they could benefit from the effort
>>> of people creating packages with the original fsverity signature.
>>>
>>> For people that are skeptical about IMA, they could be interested
>>> in trying the full solution, which would probably be more easily
>>> available if the efforts from both sides converge.
>>>
>>> If, as you say, you have concerns about the existing signature
>>> format, wouldn't it be better that you address them from the
>>> fsverity side, so that all users of fsverity can benefit from it?
>>>
>>> Currently, fsverity hashes the formatted digest whose format
>>> is FSVerity<digest algo><digest size><digest>. Couldn't IMA
>>> hash the same data as well?
>>>
>>> An idea could be to always sign the formatted digest, and have
>>> a selector for the signature format: IMA, PKCS#7 or PGP.
>> Adding support for the new IMA signature format to fsverity_verify_signature()
>> *might* make sense.  (When I added this code, my understanding was that it
>> was
>> just verifying signatures the way the kernel usually verifies signatures.  I
> Ok. Do we need something more to sign other than the fsverity
> formatted digest? If not, this could be the same for any method
> we support.
>
>> don't think I realized there was a more direct, PKCS#7-less way to do it and
>> that IMA used that way.)  However, it would be better to use this as an
>> opportunity to move people off of the built-in signatures entirely, either by
>> switching to a full userspace solution or by switching to IMA.
> If what we sign remains the same, then we could support multiple
> methods and use a selector to let fsverity_verify_signature() know
> how it should verify the signature. I don't know what would be a
> proper place for the selector.
>
> PKCS#7 seems ok, as it is used for kernel modules. IMA would be
> also ok, as it can verify the signature more directly. I would also
> be interested in supporting PGP, to avoid the requirement for
> Linux distributions to manage a secondary key. I have a small
> extension for rpmsign, that I would like to test in the Fedora
> infrastructure.
>
> Both the PKCS#7 and the PGP methods don't require additional
> support from outside, the functions verify_pkcs7_signature()
> and verify_pgp_signature() (proposed, not yet in the upstream
> kernel) would be sufficient.

FYI: An empty file signed with pkcs7 and an ecc key for NIST p256 
generates a signature of size 817 bytes. If an RPM needs to carry such 
signatures on a per-file basis we are back to the size increase of 
nearly an RSA signature. I would say for packages this is probably too 
much size increase.. and this is what drove the implementation of ECC 
support.


