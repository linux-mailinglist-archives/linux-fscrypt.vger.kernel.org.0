Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D2B463534
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Nov 2021 14:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239345AbhK3NUX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 30 Nov 2021 08:20:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22896 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232031AbhK3NUW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 30 Nov 2021 08:20:22 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AUD7qUT032112;
        Tue, 30 Nov 2021 13:17:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=0rIetcX3x6LjEhiveIf76VIp8g4avAXdpA9rIWwTqyA=;
 b=ePAaM+0SrqmxwFAdugksa7U3dRwIBTmYYfnW8z1apxi2FxXFmynUVatkIpWlP3epIxyw
 I6VxeWFqU2PropJWmRjbL54Pwwoey7Z+JUMNqeCWcUCmYoPpLIyEbg5og32N+h1jjdc0
 DnzgMEUmB1np0a2ZjWEGCtsD0asa+b9a+Igy6mwaJNEEwkajvXwhX3Kdzp38VKl07Qvr
 Qe5vq09MgmKm3hsKicKLAgEZiBjYpZn5JLLJKuPmSBdbyVF9py9pQk+VTPfJCjolkRJN
 ecZuZ4JaOYCdF5z/KJ7+kn1fcwir7V4QrqRp8xjBFI8XelozTDcFycA7YVV9NUQDnhOt EQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cnkd09qse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 13:17:00 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AUD9QiK013413;
        Tue, 30 Nov 2021 13:15:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3ckca9np14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 13:15:56 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AUDFsaW29295036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 13:15:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66385AE051;
        Tue, 30 Nov 2021 13:15:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0E14AE04D;
        Tue, 30 Nov 2021 13:15:53 +0000 (GMT)
Received: from sig-9-65-92-250.ibm.com (unknown [9.65.92.250])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Nov 2021 13:15:53 +0000 (GMT)
Message-ID: <5e4e7f69e756881a6efc1c575d74931e4ff48478.camel@linux.ibm.com>
Subject: Re: [PATCH 3/4] ima: limit including fs-verity's file digest in
 measurement list
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 30 Nov 2021 08:15:53 -0500
In-Reply-To: <YaWN2RPEO3fZqkv4@sol.localdomain>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
         <20211129170057.243127-4-zohar@linux.ibm.com>
         <YaWN2RPEO3fZqkv4@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XXzhLryAOufCLeKLbSAkt6OUgdCxbtk_
X-Proofpoint-ORIG-GUID: XXzhLryAOufCLeKLbSAkt6OUgdCxbtk_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_07,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxscore=0 phishscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111300075
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

On Mon, 2021-11-29 at 18:35 -0800, Eric Biggers wrote:
> > diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> > index 42c6ff7056e6..179c7f0364c2 100644
> > --- a/security/integrity/ima/ima_api.c
> > +++ b/security/integrity/ima/ima_api.c
> > @@ -217,7 +217,8 @@ int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
> >   */
> >  int ima_collect_measurement(struct integrity_iint_cache *iint,
> >                           struct file *file, void *buf, loff_t size,
> > -                         enum hash_algo algo, struct modsig *modsig)
> > +                         enum hash_algo algo, struct modsig *modsig,
> > +                         bool veritysig)
> 
> 'veritysig' is being added here but it doesn't actually do anything.  It seems
> this patchset is not split up correctly.

True, this patch just adds the plumbing.  Reversing 3 & 4 could result
in including the fs-verity digest, without the signature in the
measurement list.  The alternative is to squash patches 3 & 4.

thanks,

Mimi

