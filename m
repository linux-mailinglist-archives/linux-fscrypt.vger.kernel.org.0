Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9034E98AF
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Mar 2022 15:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236678AbiC1Nwb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Mar 2022 09:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbiC1Nwa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Mar 2022 09:52:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9965AEE4;
        Mon, 28 Mar 2022 06:50:50 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22SDJXXg037825;
        Mon, 28 Mar 2022 13:50:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Rszm0S6p6TmzIZCniTrbjaLJliMRHstOCG1+jay0WR0=;
 b=VKjfGB1ewapPjiXkMPXtFvrEkF9v5YqHFVYBFKBaBgryJiYgMTE1jdHdkxsKpR46RzNK
 YndD5IvhSyZQLIbcWe9B+M2nYjwRfxnM7/9dqp7Iv54zcK3kKfCNqmgonmc+6aJl6hJk
 W27OqYHgsziNnasgisCKHd+gbbiLUuK5NDxUtl90+m7LloW96vHRhWAiJvlud0DVElvi
 SRam3jyaA4puMh0hauSnULrq+YBts5Mj8OwPp20HUdTNOQG4XKBIOSLxliTWLPFdM0B9
 kF0NOTtn/4RRLBkcnjCHwfJZE1f54dBKul6N3orekUXG7hE1f0h3FWEQpaVTbhW3GSUi Iw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f3dt8rpf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 13:50:43 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22SDhWT8013405;
        Mon, 28 Mar 2022 13:50:41 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3f1tf8v3gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 13:50:40 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22SDocOI36045104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 13:50:38 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 929874C040;
        Mon, 28 Mar 2022 13:50:38 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2DC14C044;
        Mon, 28 Mar 2022 13:50:37 +0000 (GMT)
Received: from sig-9-65-77-40.ibm.com (unknown [9.65.77.40])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Mar 2022 13:50:37 +0000 (GMT)
Message-ID: <2c54d52208b1f5b3c628e6a52f5fbd0af3fff6f3.camel@linux.ibm.com>
Subject: Re: [PATCH v7 2/5] ima: define a new template field named 'd-ngv2'
 and templates
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     "Guozihua (Scott)" <guozihua@huawei.com>,
        linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 28 Mar 2022 09:50:37 -0400
In-Reply-To: <889cca45-4697-6edb-41f5-83cf6340bf32@huawei.com>
References: <20220325223824.310119-1-zohar@linux.ibm.com>
         <20220325223824.310119-3-zohar@linux.ibm.com>
         <889cca45-4697-6edb-41f5-83cf6340bf32@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M0cmhCTidW3487aI158N__5P9G1jEuTk
X-Proofpoint-ORIG-GUID: M0cmhCTidW3487aI158N__5P9G1jEuTk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_05,2022-03-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203280078
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2022-03-28 at 14:14 +0800, Guozihua (Scott) wrote:
> > @@ -265,26 +285,39 @@ int ima_parse_buf(void *bufstartp, void *bufendp, void **bufcurp,
> >   }
> >   
> >   static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
> > -                                    u8 hash_algo,
> > +                                    u8 digest_type, u8 hash_algo,
> >                                      struct ima_field_data *field_data)
> >   {
> >       /*
> >        * digest formats:
> >        *  - DATA_FMT_DIGEST: digest
> >        *  - DATA_FMT_DIGEST_WITH_ALGO: [<hash algo>] + ':' + '\0' + digest,
> > +      *  - DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO:
> > +      *      [<digest type> + ':' + <hash algo>] + ':' + '\0' + digest,
> > +      *    where <hash type> is either "ima" or "verity",
> >        *    where <hash algo> is provided if the hash algorithm is not
> >        *    SHA1 or MD5
> >        */
> > -     u8 buffer[CRYPTO_MAX_ALG_NAME + 2 + IMA_MAX_DIGEST_SIZE] = { 0 };
> > +     u8 buffer[DIGEST_TYPE_NAME_LEN_MAX + CRYPTO_MAX_ALG_NAME + 2 +
> > +             IMA_MAX_DIGEST_SIZE] = { 0 };
> 
> Hi Mimi,
> 
> Shouldn't this contains an additional ":", Thus should +1 again?

The length of the CRYPTO_MAX_ALG_NAME includes room for the terminating
NULL.  In this case, the terminating NULL isn't needed.  It's replaced
with the ':'.

thanks,

Mimi

> 
> >       enum data_formats fmt = DATA_FMT_DIGEST;
> >       u32 offset = 0;
> >   


