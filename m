Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A1F4641C6
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Nov 2021 23:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbhK3WxF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 30 Nov 2021 17:53:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34234 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233731AbhK3WxF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 30 Nov 2021 17:53:05 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AUMkZEW022501;
        Tue, 30 Nov 2021 22:49:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=z4DGoY8XdH+P+eAOKsjRpwmyvkYyrqgoRVOtJ1mts54=;
 b=c0ZTCyvQyUOkLj9Y4SL/nMoKamqeWifzw/Kquzzup4kmMh+9EsNa4DGTzCeCX9ACE9dd
 eQ4qOEyq8/Su2dRxd6GvZfndAjBNJKIk9XDbSQ6QFL63lfSjfaceM08pcUzJmK/WF7Z8
 2VtkTmXBCdwbjf+bW81avtvPJTSlAqINJ3f6InQaCNYqHH9phOwyTbFyZbatxE/b2wLu
 PaxaiSU1wfXxzrz+n7C1rNAnjyinoz+Qot1rkHjFDD88nOkg1mKIwaKp7ill6QcpoyWY
 a2P7ClwUkyH3OyxRETZ99WWbiSQg6Gx7R0atB+aIMTcoBiIvLhuQagbnN2B7TpSn+vhq xA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cnw20g2fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 22:49:41 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AUMmVwt016761;
        Tue, 30 Nov 2021 22:49:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3ckcack8w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 22:49:39 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AUMnbIU23331206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 22:49:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 369EB42042;
        Tue, 30 Nov 2021 22:49:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6885942041;
        Tue, 30 Nov 2021 22:49:36 +0000 (GMT)
Received: from sig-9-65-92-250.ibm.com (unknown [9.65.92.250])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Nov 2021 22:49:36 +0000 (GMT)
Message-ID: <2120df834ded1811b39349552c34587bb79b212d.camel@linux.ibm.com>
Subject: Re: [PATCH 0/4] ima: support fs-verity signatures stored as
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 30 Nov 2021 17:49:35 -0500
In-Reply-To: <16364d376af32a97fc6a119d4e7366862f16f417.camel@linux.ibm.com>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
         <YaWOR+Bav6PBgHHq@sol.localdomain>
         <16364d376af32a97fc6a119d4e7366862f16f417.camel@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d9HPCuipX8lWo-tm_3KfJTaE4uszF_Ov
X-Proofpoint-ORIG-GUID: d9HPCuipX8lWo-tm_3KfJTaE4uszF_Ov
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111300111
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 2021-11-30 at 07:56 -0500, Mimi Zohar wrote:
> On Mon, 2021-11-29 at 18:36 -0800, Eric Biggers wrote:
> > On Mon, Nov 29, 2021 at 12:00:53PM -0500, Mimi Zohar wrote:
> > > Support for fs-verity file digests in IMA was discussed from the beginning,
> > > prior to fs-verity being upstreamed[1,2].  This patch set adds signature
> > > verification support based on the fs-verity file digest.  Both the
> > > file digest and the signature must be included in the IMA measurement list
> > > in order to disambiguate the type of file digest.
> > > 
> > > [1] https://events19.linuxfoundation.org/wp-content/uploads/2017/11/fs-verify_Mike-Halcrow_Eric-Biggers.pdf
> > > [2] Documentation/filesystems/fsverity.rst
> > > 
> > > Mimi Zohar (4):
> > >   fs-verity: define a function to return the integrity protected file
> > >     digest
> > >   ima: define a new signature type named IMA_VERITY_DIGSIG
> > >   ima: limit including fs-verity's file digest in measurement list
> > >   ima: support fs-verity file digest based signatures
> > > 
> > >  fs/verity/fsverity_private.h              |  6 ---
> > >  fs/verity/measure.c                       | 49 +++++++++++++++++++++++
> > >  include/linux/fsverity.h                  | 17 ++++++++
> > >  security/integrity/ima/ima.h              |  3 +-
> > >  security/integrity/ima/ima_api.c          | 23 ++++++++++-
> > >  security/integrity/ima/ima_appraise.c     |  9 ++++-
> > >  security/integrity/ima/ima_main.c         |  7 +++-
> > >  security/integrity/ima/ima_template_lib.c |  3 +-
> > >  security/integrity/integrity.h            |  1 +
> > >  9 files changed, 107 insertions(+), 11 deletions(-)
> > 
> > I left some comments, but this generally looks like the right approach.
> > However, I'm not an expert in IMA, so it's hard for me to review the IMA parts.
> 
> Thank you for the quick review!
> 
> > 
> > Can you add documentation for this feature?
> 
> Yes, of course.  Originally I assumed the fs-verity support would be a
> lot more complicated, but to my pleasant surprise by limiting the IMA
> fsverity support to just signatures and requiring the file signature be
> included in the IMA measurement list, it's a lot simpler than expected.
> As there aren't any IMA policy changes, I'm just thinking about where
> to document it.

I'll update both Documentation/filesystems/fsverity.rst and
Documentation/security/IMA-templates.rst.

thanks,

Mimi

