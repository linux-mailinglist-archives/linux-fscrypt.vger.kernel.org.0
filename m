Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F62F4DCA98
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Mar 2022 16:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbiCQP7y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Mar 2022 11:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbiCQP7v (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Mar 2022 11:59:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF495BF03B;
        Thu, 17 Mar 2022 08:58:34 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22HFsWPN027305;
        Thu, 17 Mar 2022 15:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=3m4fCIq28ovG+snMQBx7uMwRJ3aY27nz3p2vh0x8Kzc=;
 b=SogeypK+ZDDWdv/8J1qiFhvoC1L0o5dwSA1XmgSbu/tH/zB0pwtu1xxrDj4+XYvuNyLx
 ofprfBAZWD3Pvb+XIBOPtRF+ZdU+Al89ls5llYT69yjG4+aJtNM06O/gRxhNM+jgDCB7
 8tLlJ/oKJ3jGyc2Sh2UVdC7c3cyfeMxaNeku1ZHaS9K707fmFtEvUSOhKQ5jjFsjRJOB
 ky1UbVj8DMVq5Iuq33QcJAdjYoF2+zp9DOLk4hFxzUs5l9qXuUJiXWAFyvdFUH7yTXzu
 jea7VpmKCNaJV7qlNlRM4HfBtnZ7xEGc+L0AQwhT+JpZ3dC6XAyTUzFxld4mQNKY3ecG jA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ev2sbq6a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 15:58:30 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22HFZ27p003140;
        Thu, 17 Mar 2022 15:58:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3erk58t000-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 15:58:28 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22HFwPO942336696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 15:58:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D975F11C052;
        Thu, 17 Mar 2022 15:58:25 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B2E811C04A;
        Thu, 17 Mar 2022 15:58:25 +0000 (GMT)
Received: from sig-9-65-73-185.ibm.com (unknown [9.65.73.185])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Mar 2022 15:58:24 +0000 (GMT)
Message-ID: <692a64e10646154ee7310b62ffd74025f29cdccf.camel@linux.ibm.com>
Subject: Re: [PATCH v5 5/8] ima: permit fsverity's file digests in the IMA
 measurement list
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 17 Mar 2022 11:58:24 -0400
In-Reply-To: <YhbUBJbQ+nCN515p@sol.localdomain>
References: <20220211214310.119257-1-zohar@linux.ibm.com>
         <20220211214310.119257-6-zohar@linux.ibm.com>
         <YhbUBJbQ+nCN515p@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QGW2ZGs_To9y4LZRuo_-huVmNLOD99c6
X-Proofpoint-GUID: QGW2ZGs_To9y4LZRuo_-huVmNLOD99c6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-17_06,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 mlxlogscore=816 lowpriorityscore=0
 suspectscore=0 bulkscore=0 phishscore=0 clxscore=1011 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203170091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

> diff --git a/security/integrity/integrity.h
b/security/integrity/integrity.h
> > index daf49894fd7d..39a999877013 100644
> > --- a/security/integrity/integrity.h
> > +++ b/security/integrity/integrity.h
> > @@ -32,7 +32,7 @@
> >  #define IMA_HASHED		0x00000200
> >  
> >  /* iint policy rule cache flags */
> > -#define IMA_NONACTION_FLAGS	0xff000000
> > +#define IMA_NONACTION_FLAGS	0xff800000
> >  #define IMA_DIGSIG_REQUIRED	0x01000000
> >  #define IMA_PERMIT_DIRECTIO	0x02000000
> >  #define IMA_NEW_FILE		0x04000000
> > @@ -40,6 +40,8 @@
> >  #define IMA_FAIL_UNVERIFIABLE_SIGS	0x10000000
> >  #define IMA_MODSIG_ALLOWED	0x20000000
> >  #define IMA_CHECK_BLACKLIST	0x40000000
> > +#define IMA_VERITY_REQUIRED	0x80000000
> > +#define IMA_VERITY_DIGEST	0x00800000
> 
> How about defining these flags in numerical order?

Originally I increased the flags size, but I'd like to avoid as much
patch churn as possible for the namespacing patch set.

Mimi

