Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02D0463D79
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Nov 2021 19:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239403AbhK3SRq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 30 Nov 2021 13:17:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50246 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239405AbhK3SRp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 30 Nov 2021 13:17:45 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AUI5Ptc008531;
        Tue, 30 Nov 2021 18:14:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=x74v3GkFpqE/81rnIgyRVZzbjMtKOCp98DXa+kxzQS8=;
 b=tHScyWPylOU/sqzWk6+FdLCzJGiVOvefDc0ZnqgxbKEA29RvuYxeuur/odN0cYoEB4Ky
 Y/sLXnxjg0+E0FqPA/OjTtrYuTcgKYl6b57IQ2CSw4t23WBRTcsom9085Qdq9cbh1IwN
 561e8EtnZpEQmn8Q0SSvcUpUqj8d5xxpYeCmxW9o45gc69LA+5fhSJmCFQvKgGAvDouu
 cnYEsngEXqJNb6MagaoA90icQe4vyBO+vmrotuDsbKNpbcj+4DNNNhoBd+61klE+sUs9
 S2p/CQHsI8K4BnMlHxYSrr3w2u5s6S07V5+toP92rHdLwq95/UiWTKSsuKb+S1ldHW+r RA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cnrqg0q26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 18:14:23 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AUIDE8O017721;
        Tue, 30 Nov 2021 18:14:21 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ckca9hnua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 18:14:21 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AUIEJAB27001116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 18:14:19 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 046F9AE051;
        Tue, 30 Nov 2021 18:14:19 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6029EAE053;
        Tue, 30 Nov 2021 18:14:18 +0000 (GMT)
Received: from sig-9-65-92-250.ibm.com (unknown [9.65.92.250])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Nov 2021 18:14:18 +0000 (GMT)
Message-ID: <6931ed7b1c7d5906bb595447fc24cd8a9b3e3d62.camel@linux.ibm.com>
Subject: Re: [PATCH 2/4] ima: define a new signature type named
 IMA_VERITY_DIGSIG
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 30 Nov 2021 13:14:11 -0500
In-Reply-To: <YaWNX3nwslG/Q2aH@sol.localdomain>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
         <20211129170057.243127-3-zohar@linux.ibm.com>
         <YaWNX3nwslG/Q2aH@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: L1d1hCTpk567AsN4aWt_K5OsIa_S6cJA
X-Proofpoint-GUID: L1d1hCTpk567AsN4aWt_K5OsIa_S6cJA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxscore=0 spamscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111300093
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2021-11-29 at 18:33 -0800, Eric Biggers wrote:
> On Mon, Nov 29, 2021 at 12:00:55PM -0500, Mimi Zohar wrote:
> > To differentiate between a regular file hash and an fs-verity file digest
> > based signature stored as security.ima xattr, define a new signature type
> > named IMA_VERITY_DIGSIG.
> > 
> > Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> 
> For this new signature type, what bytes are actually signed?  It looks like it's
> just the raw digest, which isn't sufficient since it is ambiguous.  It needs to
> include information that makes it clear what the signer is actually signing,
> such as "this is an fs-verity SHA-256 file digest".  See
> 'struct fsverity_formatted_digest' for an example of this (but it isn't
> necessary to use that exact structure).
> 
> I think the existing IMA signatures have the same problem (but it is hard for me
> to understand the code).  However, a new signature type doesn't have
> backwards-compatibility concerns, so it could be done right.

As this change should probably be applicable to all signature types,
the signature version in the  signature_v2_hdr should be bumped.  The
existing signature version could co-exist with the new signature
version.

thanks,

Mimi

