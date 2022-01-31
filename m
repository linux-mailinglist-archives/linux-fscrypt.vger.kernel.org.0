Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC434A508B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 31 Jan 2022 21:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377841AbiAaUvu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 31 Jan 2022 15:51:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38838 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378462AbiAaUvt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 31 Jan 2022 15:51:49 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VKbxlM019317;
        Mon, 31 Jan 2022 20:51:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IfFG2icOgeTcRGGdsSdqmUiXr02BVOtC/GnDf5j3uNI=;
 b=tuaCegeG9QnE+M8L1gvNV4gn2N3NrzM+i5C6ihen8ZtYouge5nUWayE6iNUlUNE1mM/R
 MPdKdE1fKeyrU/N8CitudDuv/etk5BGeRCRft0zP1+aUvM43PLORdjYTy0gMBIOA+Ckn
 lCFfv5Uz3QD3SlA/1zxloKjLRTxREWakf0FhGwOn9Tr6J20ElCx0N/4cVNqLS8gPZXnK
 /+Yr0MGWYNphboRaQybCw9KkA0ME+n9YXawIwfyq04RN1ElZwHZu5U6xEQk6GdwMOsQd
 PmDrV9p6fuU33XO3N8P6Tlw8zwKA4w3FEOr4llIMc87mNM4PZZ9HrM7/G2qDU0EoISvi Dw== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dxjcaqcyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 20:51:42 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20VKmLxQ012846;
        Mon, 31 Jan 2022 20:51:40 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 3dvw7abe1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 20:51:40 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20VKpeIA32768302
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 20:51:40 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33BE9B2066;
        Mon, 31 Jan 2022 20:51:40 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE577B2064;
        Mon, 31 Jan 2022 20:51:39 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Jan 2022 20:51:39 +0000 (GMT)
Message-ID: <b36b49c9-479f-8a33-c6d6-1cb00939150f@linux.ibm.com>
Date:   Mon, 31 Jan 2022 15:51:39 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [RFC][PATCH v3a 00/11] ima: support fs-verity digests and
 signatures (alternative)
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220127184614.2837938-1-roberto.sassu@huawei.com>
 <YfLz8NftvbZtKvLT@sol.localdomain> <YfL0+q/ekv4H8lZg@sol.localdomain>
 <d122893c426f44aa95d5168773b60b9d@huawei.com>
 <YfRRUBZpQv2Hi1sL@sol.localdomain>
 <9af14af14beb46a28f57559e4b1dc1a7@huawei.com>
 <b262cb06-37fd-9760-8f6e-1dcacbf738b4@linux.ibm.com>
 <YfhFgtg4X1DLJtAQ@gmail.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <YfhFgtg4X1DLJtAQ@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o7_XE9-Hh7P0BMQXHullAo0lFjXb7rKf
X-Proofpoint-ORIG-GUID: o7_XE9-Hh7P0BMQXHullAo0lFjXb7rKf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_07,2022-01-31_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310130
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 1/31/22 15:24, Eric Biggers wrote:
> On Mon, Jan 31, 2022 at 02:29:19PM -0500, Stefan Berger wrote:
>>>> don't think I realized there was a more direct, PKCS#7-less way to do it and
>>>> that IMA used that way.)  However, it would be better to use this as an
>>>> opportunity to move people off of the built-in signatures entirely, either by
>>>> switching to a full userspace solution or by switching to IMA.
>>> If what we sign remains the same, then we could support multiple
>>> methods and use a selector to let fsverity_verify_signature() know
>>> how it should verify the signature. I don't know what would be a
>>> proper place for the selector.
>>>
>>> PKCS#7 seems ok, as it is used for kernel modules. IMA would be
>>> also ok, as it can verify the signature more directly. I would also
>>> be interested in supporting PGP, to avoid the requirement for
>>> Linux distributions to manage a secondary key. I have a small
>>> extension for rpmsign, that I would like to test in the Fedora
>>> infrastructure.
>>>
>>> Both the PKCS#7 and the PGP methods don't require additional
>>> support from outside, the functions verify_pkcs7_signature()
>>> and verify_pgp_signature() (proposed, not yet in the upstream
>>> kernel) would be sufficient.
>> FYI: An empty file signed with pkcs7 and an ecc key for NIST p256 generates
>> a signature of size 817 bytes. If an RPM needs to carry such signatures on a
>> per-file basis we are back to the size increase of nearly an RSA signature.
>> I would say for packages this is probably too much size increase.. and this
>> is what drove the implementation of ECC support.
> I am getting 256 bytes for an ECC signature in PKCS#7 format:
>
> 	cd src/fsverity-utils
> 	make
> 	openssl ecparam -name prime256v1 -genkey -noout -out key.pem
> 	openssl req -new -x509 -key key.pem -out cert.pem -days 360
> 	touch file
> 	./fsverity sign file file.sig --key=key.pem --cert=cert.pem
> 	stat -c %s file.sig
>
> Probably you accidentally included the whole certificate in the PKCS#7 message.
> That's not required here.
>
> There are definitely problems with PKCS#7, and it does have space overhead.  But
> the space overhead is not as bad as you state.

You are right. I used openssl cms without -nocerts and -noattr 
(unintentionately). Though 256 bytes is RSA 2048 signature size again. 
ECDSA with NIST p256 key is around 70 bytes.


>
> - Eric
