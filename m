Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B1D4A64E1
	for <lists+linux-fscrypt@lfdr.de>; Tue,  1 Feb 2022 20:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbiBATUk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 1 Feb 2022 14:20:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231995AbiBATUk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 1 Feb 2022 14:20:40 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211HSebI030188;
        Tue, 1 Feb 2022 19:20:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=mmmrdFnRzQRQfT2NKuNtQBEU3jTRR0poIgzM27mY82U=;
 b=DQ32H/5vYs7QQT2CN7FnchW4233osBzbyaGAJjg8Oim2hA9sEbk1U+ac/09CKBdavy4D
 QsADw1ADnktfqkWMbuoYdMNzKNN/3ZXQprF2ASWZmviz1sx/CQdX3Kop8G17CYvkRoow
 8ziRbAp7d4sWynH435Y8SJxq0qS74V/T1zCMu/MUdOCZ0SFVpWbURWl7jxuoslPpQjuK
 kGcZVz221/Vmflb+9mf+a59gi3WTVIobfRZaNm80EaWfKqSmgsYZvCVBFZbatDxOh8t5
 07iLDig8HZsTfLfa5EAu6x2ITFJ96SWN6o4L2CnEZcK/QlNG6WwnscQbEQMz2WDhiHgC Qw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dy9a0t2d1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Feb 2022 19:20:37 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 211JEkDn020382;
        Tue, 1 Feb 2022 19:20:36 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3dvw79qj1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Feb 2022 19:20:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 211JKXpo26411428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Feb 2022 19:20:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4E3BAE05A;
        Tue,  1 Feb 2022 19:20:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5DFFAE055;
        Tue,  1 Feb 2022 19:20:32 +0000 (GMT)
Received: from sig-9-65-85-8.ibm.com (unknown [9.65.85.8])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Feb 2022 19:20:32 +0000 (GMT)
Message-ID: <927aff512bfa28ed77126f97d4a3fea2734c7690.camel@linux.ibm.com>
Subject: Re: [PATCH v3 0/8] ima: support fs-verity digests and signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 01 Feb 2022 14:20:32 -0500
In-Reply-To: <YfiAoKiFdkXte7PW@sol.localdomain>
References: <20220126000658.138345-1-zohar@linux.ibm.com>
         <YfiAoKiFdkXte7PW@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OtC-8Xs0-6tgAtT5hfuEVze09vMb3Vem
X-Proofpoint-ORIG-GUID: OtC-8Xs0-6tgAtT5hfuEVze09vMb3Vem
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-01_09,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxlogscore=947 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202010108
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2022-01-31 at 16:36 -0800, Eric Biggers wrote:
> On Tue, Jan 25, 2022 at 07:06:50PM -0500, Mimi Zohar wrote:
>  
> > Support including fs-verity file digests in the 'd-ng' template field
> > based on a new policy rule option named 'digest_type=hash|verity'.
> 
> Perhaps it should be full_hash or verity?  verity is a type of hash.

Ok, but instead of "full_hash", let's rename it to "ima" or "verity".

thanks,

Mimi

