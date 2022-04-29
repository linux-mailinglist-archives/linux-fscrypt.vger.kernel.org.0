Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6751C515706
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 Apr 2022 23:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbiD2Voc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 Apr 2022 17:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237955AbiD2Vob (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 Apr 2022 17:44:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB895DA59;
        Fri, 29 Apr 2022 14:41:12 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TLVOT4021288;
        Fri, 29 Apr 2022 21:41:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=j+s8ZQMPKlBFOKUQOHw4jpURzDyrn4Xu6MhLmXlQSa0=;
 b=si5++2xbEVJcNmQJB8Y9BPHsPtE/Pd0IzUsan9yv3mZG/W7lPLv3YzFBWxi0z8LslSds
 Utd9/GD6sbxbm03xu87WW4chnxQS9yDaHNhy92GwbwLQ0Mwczi3+3JDvcsvm7jsyHlF/
 0qSYepNXkT7BdCMqpMU40eHv2whdWJy4DZIy7OfvriJQW9NiFQxJxx/pIFWqMvCh9/mJ
 iNUGHJe0lBB0+jrxx2y40dJLoW/vGGmlFpI2ZkCj5M84lESYQ9KGrBP4OGaYC00hjWI9
 vFmmgaQdmUFUv5PF/mSMJWLF1IrqrGqjI/HLN10bic7csNCiT2EsctxLWg2Vij69IzSf Yw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqtdnnaj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 21:41:10 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23TLc91t019335;
        Fri, 29 Apr 2022 21:41:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3fm8qj9n98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 21:41:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23TLf5Qt27197730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 21:41:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB52511C050;
        Fri, 29 Apr 2022 21:41:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB96511C04C;
        Fri, 29 Apr 2022 21:41:04 +0000 (GMT)
Received: from sig-9-65-75-248.ibm.com (unknown [9.65.75.248])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Apr 2022 21:41:04 +0000 (GMT)
Message-ID: <c317858898c7974b5f046f9fb8117d299f0c6504.camel@linux.ibm.com>
Subject: Re: [PATCH v8 4/7] ima: define a new template field named 'd-ngv2'
 and templates
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Stefan Berger <stefanb@linux.ibm.com>,
        linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 29 Apr 2022 17:41:04 -0400
In-Reply-To: <026c9596-9ebe-d148-fc5f-442a7e16f48b@linux.ibm.com>
References: <20220429112601.1421947-1-zohar@linux.ibm.com>
         <20220429112601.1421947-5-zohar@linux.ibm.com>
         <026c9596-9ebe-d148-fc5f-442a7e16f48b@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VwRJbrI1-N6IZDhkjxfR16oQ8w24TlsD
X-Proofpoint-ORIG-GUID: VwRJbrI1-N6IZDhkjxfR16oQ8w24TlsD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_09,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290115
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 2022-04-29 at 11:09 -0400, Stefan Berger wrote:
> > -     if (hash_algo < HASH_ALGO__LAST) {
> > +     if (digest_type < DIGEST_TYPE__LAST && hash_algo < HASH_ALGO__LAST) {
> > +             fmt = DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO;
> > +             offset += 1 + sprintf(buffer, "%*s:%*s:",
> > +                                   (int)strlen(digest_type_name[digest_type]),
> > +                                   digest_type_name[digest_type],
> > +                                   (int)strlen(hash_algo_name[hash_algo]),
> > +                                   hash_algo_name[hash_algo]);
> 
> '%*s' seems to be for right-alignment but only makes sense if the length 
> indicator is different than then following string. sprintf(buffer, 
> "|%*s|",5,"test") prints | test|. Otherwise it seems to behave like 
> plain '%s' in this case... ?

Re-testing now, it works properly without the length.

thanks,

Mimi

