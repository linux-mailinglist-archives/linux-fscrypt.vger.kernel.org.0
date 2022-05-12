Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2785E5257FB
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 May 2022 00:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359292AbiELWsg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 May 2022 18:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359291AbiELWse (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 May 2022 18:48:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506E421A972;
        Thu, 12 May 2022 15:48:31 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CLNPZw019593;
        Thu, 12 May 2022 22:48:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=5Y0pz5rcvdH1HP8ESBafNVjAbPV769xSmrAavLKXXvI=;
 b=o5F5CSJZKL4E56YlJjVV4pjiD7r82A8YOeiJ8I+Z3CHpaWKSssq1aG++OcVV5TtSBGzN
 8atcE3rgrD5iGmAJSNy0XfrqVFUbTFaK0qaQZQLojtVW7kT8oFr4F/hn6NNK5tVkjgP+
 vyMYlErpFJaVqX1rMD/pGRWbK12QWQ27li6pAZwF4Lseui6MDBk5hZQ6nenZhOVyIcLv
 Y34E504AipQW2lCk95ckhiRMLpTE9VhoEBolTPFigFTeKEtlaWAVSOUpFlLqPQZ0KauE
 xG4cNeIdvhKA43Ty94YsctDOHJItE0j39LKciJofKZoJfdhcw4meQVx3uP/YxgK4h2d3 GA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1a41h882-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 22:48:27 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24CMlkqo007447;
        Thu, 12 May 2022 22:48:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3fyrkk3j6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 22:48:25 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24CMmNBO53477708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 22:48:23 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99645AE04D;
        Thu, 12 May 2022 22:48:23 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB351AE045;
        Thu, 12 May 2022 22:48:22 +0000 (GMT)
Received: from sig-9-65-84-154.ibm.com (unknown [9.65.84.154])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 22:48:22 +0000 (GMT)
Message-ID: <0504ee350755f7c154f5ef0ace55b79902744133.camel@linux.ibm.com>
Subject: Re: [PATCH v9 7/7] fsverity: update the documentation
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 12 May 2022 18:48:22 -0400
In-Reply-To: <Ynym39Y++2zAiWOx@sol.localdomain>
References: <20220505123141.1599622-1-zohar@linux.ibm.com>
         <20220505123141.1599622-8-zohar@linux.ibm.com>
         <Ynym39Y++2zAiWOx@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xis4VEHEgrRo90naro7016DNeRGdhdUC
X-Proofpoint-ORIG-GUID: xis4VEHEgrRo90naro7016DNeRGdhdUC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_19,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=763 malwarescore=0 spamscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120096
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2022-05-11 at 23:19 -0700, Eric Biggers wrote:
> On Thu, May 05, 2022 at 08:31:41AM -0400, Mimi Zohar wrote:
> > Update the fsverity documentation related to IMA signature support.
> > 
> > Acked-by: Stefan Berger <stefanb@linux.ibm.com>
> > Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> > ---
> >  Documentation/filesystems/fsverity.rst | 35 +++++++++++++++++---------
> >  1 file changed, 23 insertions(+), 12 deletions(-)
> 
> Acked-by: Eric Biggers <ebiggers@google.com>

Thanks, Eric.

