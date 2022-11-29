Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B2763BF13
	for <lists+linux-fscrypt@lfdr.de>; Tue, 29 Nov 2022 12:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbiK2LdZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 29 Nov 2022 06:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbiK2LdF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 29 Nov 2022 06:33:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9E843AC5;
        Tue, 29 Nov 2022 03:32:57 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATAJN7G018479;
        Tue, 29 Nov 2022 11:32:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=omSqsIfuyTuoXMdIXJRmFfrCa5/UqH9SOTlZpsA4YNU=;
 b=kPFBXJYg6MZOAp7OBPYVJ8ezrdzwVNfrsswvHEbmM1sSdgaU2DNzcSIcVsON3q5sJPEM
 fPRn4emX27k3NFh69c1SwPezTxrTvYsMSb98muxT1uBecKzIByX/t0CQ3YFBhDW7J3A/
 6YnPdEAoVX8Pc26C3ah0LlPI5u/Pvq/czRH+oXIhsd5HGGwpVzByFFsGnPGCt82w3RGP
 dHj46jLd+9a1dtEn9vioPx2vpVseqBKJ25jHk+m9l+zDMVgWHworq69XxLGBP36sR1lC
 Vf5oxFWbLviRQNY88aV2yy4jOTgxmjcQ2vk1hEiWK1OzRzp61Bp17p1Rb9OdyLvKs3VW +w== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5e0pngq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 11:32:49 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ATBLO2L030074;
        Tue, 29 Nov 2022 11:32:48 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03wdc.us.ibm.com with ESMTP id 3m3ae9c78g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 11:32:48 +0000
Received: from smtpav05.wdc07v.mail.ibm.com ([9.208.128.117])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ATBWlSJ10945278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 11:32:47 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD51C5805F;
        Tue, 29 Nov 2022 11:32:46 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37A675805D;
        Tue, 29 Nov 2022 11:32:46 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.96.78])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 29 Nov 2022 11:32:46 +0000 (GMT)
Message-ID: <895c5afca8f2f39b60b87377c6817ce4eccb1f92.camel@linux.ibm.com>
Subject: Re: [PATCH] fsverity: simplify fsverity_get_digest()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc:     linux-integrity@vger.kernel.org
Date:   Tue, 29 Nov 2022 06:32:45 -0500
In-Reply-To: <20221129045139.69803-1-ebiggers@kernel.org>
References: <20221129045139.69803-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VRatynt0-z2K7crmC-ckyb-zSmw2C5Rx
X-Proofpoint-ORIG-GUID: VRatynt0-z2K7crmC-ckyb-zSmw2C5Rx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_07,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 adultscore=0 spamscore=0 clxscore=1011 impostorscore=0
 bulkscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=899
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2022-11-28 at 20:51 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Instead of looking up the algorithm by name in hash_algo_name[] to get
> its hash_algo ID, just store the hash_algo ID in the fsverity_hash_alg
> struct.  Verify at build time that every fsverity_hash_alg has a valid
> hash_algo ID with matching digest size.
> 
> Remove an unnecessary memset() of the whole digest array to 0 before the
> digest is copied into it.
> 
> Finally, remove the pr_debug statement.  There is already a pr_debug for
> the fsverity digest when the file is opened.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Agreed, much simpler. 
   Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

