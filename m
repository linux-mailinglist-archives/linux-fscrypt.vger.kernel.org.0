Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E847C466D5F
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 23:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245389AbhLBXBc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 18:01:32 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12278 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236694AbhLBXBb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 18:01:31 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2MGtXS029493;
        Thu, 2 Dec 2021 22:58:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=kQ900pdpsfGN7oV8j0rCVyL20q9/KG0hJYA2IrvB/4E=;
 b=kLGq8EeC0afJ71+AAyBQBvKGF/KqkaFEfSmNwGNIMRkodkKFEtveR1BRZ79sKjNh0Ctn
 d6f1+G3/9blrO32OWA6Fo4fwyVVLbytPzhz5XfT8cNLwRnd1LvUEfwKyc8HaXabF4DVl
 C1KpX+FSDIlMxfJdq7jQxAMil3VkkeAGC3TODqs7ZYoYAPS7HkxcLi3R3/4Jez+iqgFv
 pru1lNr6Y+aWLmB5xcQLflX0mAFwHWKZfP7/Hy1mlH88liAQ6kdsO/TVL78/rOYafJwo
 +itIT0Kfesaw5WmLvPlv8r+aTaqmLoASMBVGqG/OC79j4eOYI2as6VbHgVDIh/VgXGGv 8w== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cq6t5h1jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 22:58:04 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2MYD7K031209;
        Thu, 2 Dec 2021 22:56:03 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3ckbxkrr0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 22:56:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2MmUml29098286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 22:48:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6D10AE051;
        Thu,  2 Dec 2021 22:56:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D8C9AE045;
        Thu,  2 Dec 2021 22:56:00 +0000 (GMT)
Received: from sig-9-65-72-23.ibm.com (unknown [9.65.72.23])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Dec 2021 22:55:59 +0000 (GMT)
Message-ID: <0db4f4098e98b8feec7c28eca127bc450989d05a.camel@linux.ibm.com>
Subject: Re: [PATCH v1 3/5] ima: limit including fs-verity's file digest in
 measurement list
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 02 Dec 2021 17:55:59 -0500
In-Reply-To: <YalHCz/FzQXKHx4u@sol.localdomain>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
         <20211202215507.298415-4-zohar@linux.ibm.com>
         <YalHCz/FzQXKHx4u@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: p4sWjcGLC2qOLDa9rORF1DOGsrnACCp-
X-Proofpoint-GUID: p4sWjcGLC2qOLDa9rORF1DOGsrnACCp-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-02_15,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 spamscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112020137
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 2021-12-02 at 14:22 -0800, Eric Biggers wrote:
> On Thu, Dec 02, 2021 at 04:55:05PM -0500, Mimi Zohar wrote:
> > Without the file signature included in the IMA measurement list, the type
> > of file digest is unclear.  Set up the plumbing to limit including
> > fs-verity's file digest in the IMA measurement list based on whether the
> > template name is ima-sig.  In the future, this could be relaxed to include
> > any template format that includes the file signature.
> > 
> 
> Does it make sense to tie IMA's fs-verity support to files having signatures?
> What about IMA audit mode?  I thought that is just about collecting hashes, and
> has nothing to do with signatures.

There's IMA-measurement, IMA-audit, and IMA-appraisal.  IMA-audit
refers to adding the file hash to the audit log record.  IMA-
measurement stores the collected hash in the IMA measurement list and
extends the TPM with the measurement, if there's a TPM.  Based on
policy, determines whether the file is measured, audited, and/or
appraised.  I actually do think it makes sense to require a signature,
but not necessarily enforce signature verification, in order to
differentiate the type of measurement being included in the measurement
list.

thanks,

Mimi

