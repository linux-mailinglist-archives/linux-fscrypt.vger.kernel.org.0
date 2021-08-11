Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50CBA3E8F7D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Aug 2021 13:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237346AbhHKLfK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 Aug 2021 07:35:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8898 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237323AbhHKLfK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 Aug 2021 07:35:10 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17BBWsh8128241;
        Wed, 11 Aug 2021 07:34:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=WKV0mifP9mdv8ecyMfTa0U/d4OeeOKmNT+j0H4eQvJk=;
 b=hH9bPsD7c2pVAMfOhj4RRDHnxRRv2Bzx7DYgxiHRupsbbeBh6W+vBmIYsXxk1TG7Bhid
 8rKKHR+Y3VJgFF8pCXs0D9awrfRW5aNEnOyWZkZ8UJBOmkeeO1Yc8cQB0kb8YeVe2TcN
 /FQVZtjPg+pAZleKOsrmjttH4PpR5qfi0LGJZ6eYAGJFgkhSJAcml1QQVcwvQfnEM+wQ
 InpRu/GmkR/GPCSqGcxORgZ84oGIAeys2hvhsZKAEr+H8tOGJuWrg+DAaz5P8Rj0PdzY
 AN5c28/RHpjrmcH1h7E0ys0KBnfFQ1p0G5M/PD+fcb6yMfjPKYZhLZLJEbbJbk23AYrv wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acbt3jyg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 07:34:28 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17BBYR1v138486;
        Wed, 11 Aug 2021 07:34:28 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acbt3jyeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 07:34:27 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17BBXGG5011004;
        Wed, 11 Aug 2021 11:34:25 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3a9ht8yxs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 11:34:24 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17BBYMo128377392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Aug 2021 11:34:22 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73D28A4059;
        Wed, 11 Aug 2021 11:34:22 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39878A404D;
        Wed, 11 Aug 2021 11:34:19 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.27.84])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 Aug 2021 11:34:19 +0000 (GMT)
Message-ID: <d4f5c2593380c82ceebae2c8782a1c440b35f165.camel@linux.ibm.com>
Subject: Re: [PATCH v2] fscrypt: support trusted keys
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
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
Date:   Wed, 11 Aug 2021 07:34:18 -0400
In-Reply-To: <20210811001743.ofzkwdwa6rcjsf4d@kernel.org>
References: <20210806150928.27857-1-a.fatoum@pengutronix.de>
         <20210809094408.4iqwsx77u64usfx6@kernel.org> <YRGVcaquAJiuc8bp@gmail.com>
         <20210810180636.vqwaeftv7alsodgn@kernel.org> <YRLJmaafp941uOdA@gmail.com>
         <20210810212140.sdq5dq2wy5uaj7h7@kernel.org> <YRLvPJehAeMiYb2Z@gmail.com>
         <20210811001743.ofzkwdwa6rcjsf4d@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: r6-4IUomzcvJFMnp_seKefxgZMrV5TsK
X-Proofpoint-ORIG-GUID: 9YaVVr2iQJOX9DHzgWTnnrzbsVhn8PWv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-11_04:2021-08-11,2021-08-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxlogscore=751 adultscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 clxscore=1011
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108110073
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2021-08-11 at 03:17 +0300, Jarkko Sakkinen wrote:
> On Tue, Aug 10, 2021 at 02:27:24PM -0700, Eric Biggers wrote:
> > On Wed, Aug 11, 2021 at 12:21:40AM +0300, Jarkko Sakkinen wrote:
> > > On Tue, Aug 10, 2021 at 11:46:49AM -0700, Eric Biggers wrote:
> > > > On Tue, Aug 10, 2021 at 09:06:36PM +0300, Jarkko Sakkinen wrote:
> > > > > > > 
> > > > > > > I don't think this is right, or at least it does not follow the pattern
> > > > > > > in [*]. I.e. you should rather use trusted key to seal your fscrypt key.
> > > > > > 
> > > > > > What's the benefit of the extra layer of indirection over just using a "trusted"
> > > > > > key directly?  The use case for "encrypted" keys is not at all clear to me.
> > > > > 
> > > > > Because it is more robust to be able to use small amount of trusted keys,
> > > > > which are not entirely software based.
> > > > > 
> > > > > And since it's also a pattern on existing kernel features utilizing trusted
> > > > > keys, the pressure here to explain why break the pattern, should be on the
> > > > > side of the one who breaks it.
> > > > 
> > > > This is a new feature, so it's on the person proposing the feature to explain
> > > > why it's useful.  The purpose of "encrypted" keys is not at all clear, and the
> > > > documentation for them is heavily misleading.  E.g.:
> > > > 
> > > >     "user space sees, stores, and loads only encrypted blobs"
> > > >     (Not necessarily true, as I've explained previously.)
> > > > 
> > > >     "Encrypted keys do not depend on a trust source" ...  "The main disadvantage
> > > >     of encrypted keys is that if they are not rooted in a trusted key"
> > > >     (Not necessarily true, and in fact it seems they're only useful when they
> > > >     *do* depend on a trust source.  At least that's the use case that is being
> > > >     proposed here, IIUC.)
> > > > 
> > > > I do see a possible use for the layer of indirection that "encrypted" keys are,
> > > > which is that it would reduce the overhead of having lots of keys be directly
> > > > encrypted by the TPM/TEE/CAAM.  Is this the use case?  If so, it needs to be
> > > > explained.
> > > 
> > > If trusted keys are used directly, it's an introduction of a bottleneck.
> > > If they are used indirectly, you can still choose to have one trusted
> > > key per fscrypt key.
> > > 
> > > Thus, it's obviously a bad idea to use them directly.
> > 
> > So actually explain that in the documentation.  It's not obvious at all.  And
> > does this imply that the support for trusted keys in dm-crypt is a mistake?
> 
> Looking at dm-crypt implementation, you can choose to use 'encrypted' key
> type, which you can seal with a trusted key.
> 
> Note: I have not been involved when the feature was added to dm-crypt.

At least for TPM 1.2,  "trusted" keys may be sealed to a PCR and then
extended to prevent subsequent usage.  For example, in the initramfs
all of the "encrypted" keys could be decrypted by a single "trusted"
key, before extending the PCR.

Mimi

