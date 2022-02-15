Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF9D4B7547
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Feb 2022 21:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237713AbiBOSLv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Feb 2022 13:11:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235191AbiBOSLu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Feb 2022 13:11:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1627119433;
        Tue, 15 Feb 2022 10:11:39 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FGDFan030060;
        Tue, 15 Feb 2022 18:11:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=f2sl2vrF5Du39vLhEqi94RE6S3He2uQNXfw3pVxQB+4=;
 b=PeUGiT1izDi1oKNZPaX5T67thkz8ajhYm6VSX1QRCigMNAuqlFEkOfkQ8pFKZpy5wkxn
 XmbF7bIt+YM+u2iXTQ43AAjdCxlgPG7wkL4q242JRubGSwKOE+A3iQo6pDG/w77hTPFn
 URsmlhhZuq14y5f6HMq4Z/eTrravUVC3hP6k9FJO/b0e4P33RSyqxD4TQf1anW/snCrz
 Q3XKJToHirti1CD4NQFsYMmkSz75u7GFb+olqT47i4ieIf2WD4dWypXTPCkliO9iwUi9
 T5BzWW+nzx1wePVf2wj9J6MBfJwRsHCN15+AvG4Hk2Pf4tMEoaW2U7gmyr6vIfh85i33 rA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e8ekvmqme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 18:11:36 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FIAAqJ020040;
        Tue, 15 Feb 2022 18:11:35 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3e645jrju1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 18:11:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21FIBXl144040626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 18:11:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DBE811C054;
        Tue, 15 Feb 2022 18:11:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37D7311C050;
        Tue, 15 Feb 2022 18:11:32 +0000 (GMT)
Received: from sig-9-65-88-149.ibm.com (unknown [9.65.88.149])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 18:11:32 +0000 (GMT)
Message-ID: <b59e8bc8f6b880ab16d4b883a32b537321f513d4.camel@linux.ibm.com>
Subject: Re: [PATCH v5 1/8] ima: rename IMA_ACTION_FLAGS to
 IMA_NONACTION_FLAGS
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Stefan Berger <stefanb@linux.ibm.com>,
        linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 15 Feb 2022 13:11:31 -0500
In-Reply-To: <ea619561-fe29-6864-0a07-a49dee8549ab@linux.ibm.com>
References: <20220211214310.119257-1-zohar@linux.ibm.com>
         <20220211214310.119257-2-zohar@linux.ibm.com>
         <ea619561-fe29-6864-0a07-a49dee8549ab@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n0wWR8g5qFmDprcTzT_eMi_FRUarSV0v
X-Proofpoint-ORIG-GUID: n0wWR8g5qFmDprcTzT_eMi_FRUarSV0v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_05,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 mlxlogscore=900 lowpriorityscore=0 impostorscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2022-02-14 at 15:03 -0500, Stefan Berger wrote:
> On 2/11/22 16:43, Mimi Zohar wrote:
> > Simple policy rule options, such as fowner, uid, or euid, can be checked
> > immediately, while other policy rule options, such as requiring a file
> > signature, need to be deferred.
> >
> > The 'flags' field in the integrity_iint_cache struct contains the policy
> > action', 'subaction', and non action/subaction.
> >
> > action: measure/measured, appraise/appraised, (collect)/collected,
> >          audit/audited
> > subaction: appraise status for each hook (e.g. file, mmap, bprm, read,
> >          creds)
> > non action/subaction: deferred policy rule options and state
> >
> > Rename the IMA_ACTION_FLAGS to IMA_NONACTION_FLAGS.
> >
> > Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> 
> Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>

Thanks, Stefan.  Both 1/8 & 2/8 cleanup are now queued in next-
integrity.

-- 
thanks,

Mimi

