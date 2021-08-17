Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1A43EEDCD
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Aug 2021 15:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhHQN4P (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Aug 2021 09:56:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234446AbhHQN4P (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Aug 2021 09:56:15 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HDX5Pv013840;
        Tue, 17 Aug 2021 09:55:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=d5CdiPTaTbyN6eBruDpCa+DfpS0jXhFLk6hNMHqtTks=;
 b=dnX/odEzbO5FT0vctTpoBElB6/bsA9T1DKMoLqiqjjtl6Sc9/5kaaLZrx+6Ynt5xjsuO
 NBKRmAlPQLiaeZV1ZVlVN4ZwxbAkVQ5GCRL4TWBfTvWbvhgsmBrww+fggOJ4D5qSLY3m
 VnFckV1X26W0OxERjHPbwxAUJx7zvCUJpy4CBPksNGxI1B117gaO4+wIubupVzkQXWdd
 X1TY7cBVXprgEh3/S8Q/stug1Sh3T3hG4Bo0wG/BmgHSiAe/GKyqd3F/YoMIowID5HaT
 EOVpn/YiMWXaJTKAfq/p8dtAkBTo4fy5I1ahwDhfrp00tGT+rTOTDz1ukuzAepAKQFSM sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aftx54vkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 09:55:23 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17HDXGjh014864;
        Tue, 17 Aug 2021 09:55:23 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aftx54vjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 09:55:22 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17HDr1Fm014483;
        Tue, 17 Aug 2021 13:55:21 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3ae5f8vbkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 13:55:21 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17HDpoAd51446024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 13:51:50 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 720D8A40E9;
        Tue, 17 Aug 2021 13:55:18 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF9DBA4164;
        Tue, 17 Aug 2021 13:55:14 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.53.55])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Aug 2021 13:55:14 +0000 (GMT)
Message-ID: <285cb263d9c1c16f3918c98dd36074ef16568e6d.camel@linux.ibm.com>
Subject: Re: [PATCH v2] fscrypt: support trusted keys
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Eric Biggers <ebiggers@kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel@pengutronix.de,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        David Howells <dhowells@redhat.com>,
        linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 17 Aug 2021 09:55:13 -0400
In-Reply-To: <a6eb6f38-b9f4-c59c-4181-2049f181e67d@pengutronix.de>
References: <20210806150928.27857-1-a.fatoum@pengutronix.de>
         <20210809094408.4iqwsx77u64usfx6@kernel.org> <YRGVcaquAJiuc8bp@gmail.com>
         <20210810180636.vqwaeftv7alsodgn@kernel.org> <YRLJmaafp941uOdA@gmail.com>
         <20210810212140.sdq5dq2wy5uaj7h7@kernel.org> <YRLvPJehAeMiYb2Z@gmail.com>
         <20210811001743.ofzkwdwa6rcjsf4d@kernel.org>
         <d4f5c2593380c82ceebae2c8782a1c440b35f165.camel@linux.ibm.com>
         <YRQF09f8st95yrFZ@gmail.com>
         <0e69a0aa394dd20347b06ae4e700aa17d52583ef.camel@linux.ibm.com>
         <a6eb6f38-b9f4-c59c-4181-2049f181e67d@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 84Uu5U7eFAAITP33Xd2m5v2Efn7dIvZS
X-Proofpoint-GUID: NuLZMrF0yc_lhQFtdjmqZyNLX9OYWT19
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-17_04:2021-08-17,2021-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108170082
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 2021-08-17 at 15:04 +0200, Ahmad Fatoum wrote:
> Hi,
> 
> On 12.08.21 02:54, Mimi Zohar wrote:
> > On Wed, 2021-08-11 at 10:16 -0700, Eric Biggers wrote:
> > 
> >> Neither of you actually answered my question, which is whether the support for
> >> trusted keys in dm-crypt is a mistake.  I think you're saying that it is?  That
> >> would imply that fscrypt shouldn't support trusted keys, but rather encrypted
> >> keys -- which conflicts with Ahmad's patch which is adding support for trusted
> >> keys.  Note that your reasoning for this is not documented at all in the
> >> trusted-encrypted keys documentation; it needs to be (email threads don't really
> >> matter), otherwise how would anyone know when/how to use this feature?
> > 
> > True, but all of the trusted-encrypted key examples in the
> > documentation are "encrypted" type keys, encrypted/decrypted based on a
> > "trusted" type key.  There are no examples of using the "trusted" key
> > type directly.  Before claiming that adding "trusted" key support in
> > dm-crypt was a mistake, we should ask Ahmad why he felt dm-crypt needed
> > to directly support "trusted" type keys.
> 
> I wanted to persist the dm-crypt key as a sealed blob. With encrypted keys,
> I would have to persist and unseal two blobs (load trusted key blob, load
> encrypted key blob rooted to trusted key) with no extra benefit.
> 
> I thus added direct support for trusted keys. Jarkko even commented on the
> thread, but didn't voice objection to the approach (or agreement for that
> matter), so I assumed the approach is fine.
> 
> I can see the utility of using a single trusted key for TPMs, but for CAAM,
> I see none and having an encrypted key for every trusted key just makes
> it more cumbersome.
> 
> In v1 here, I added encrypted key support as well, but dropped it for v2,
> because I am not in a position to justify its use. Now that you and Eric
> discussed it, should I send v3 with support for both encrypted and trusted
> keys like with dm-crypt or how should we proceed?

With some applications, the indirection is important.   It allows the
"encrypted" key type to be updated/re-encypted based on a new "trusted"
key, without affecting the on disk encrypted key usage.

As much as I expected, directly using "trusted" keys is a result of the
new trusted key sources.  I have no opinion as to whether this is/isn't
a valid usecase.

thanks,

Mimi

