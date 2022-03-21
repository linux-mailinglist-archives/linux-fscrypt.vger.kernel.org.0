Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20ECE4E2740
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Mar 2022 14:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347744AbiCUNLy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Mar 2022 09:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbiCUNLy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Mar 2022 09:11:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8BC1D0EF;
        Mon, 21 Mar 2022 06:10:29 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22LAj81a024285;
        Mon, 21 Mar 2022 13:10:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dSRhfx3VoPovZmn5BHzSX5JfMdqftW5QA/0PFRNnjIU=;
 b=N4qjJhSIO1OgRK8iEblIGGnpKt31Mh9fCuLWWBphMuypKwzquZAaAjJMz/u1hntvOXi5
 kAQl/EmifPR5lmUXYT+edCKN6sFX2J1yqs3RyvO9b7RAeM5rlzG71E1N8jDWZOOTX2/M
 LQBQKmD+fbQbDcN7xqd8xKc+MNBIQ1xdAq3iwUS97mmXd/5YP/F8SS8dM3QrF5uuuju5
 rj0KgbDSftWHmCT4XORpXkwdk2i3g64l7m591Zdu87/5shmrWwzfvBfbFZe9zYaZ20eo
 mkbGHxvPCli03/SPyy92gOiTt1/ROLrqutlLcTCuUcNHZ8p4KC+M2fsoO2D7CyGT6bLf Rw== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exmwkexqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 13:10:26 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LCvTUF020282;
        Mon, 21 Mar 2022 13:10:25 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04wdc.us.ibm.com with ESMTP id 3exd3j3tsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 13:10:25 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LDAOAF29098254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 13:10:24 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 173C46A04D;
        Mon, 21 Mar 2022 13:10:24 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2EA76A04F;
        Mon, 21 Mar 2022 13:10:22 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 13:10:22 +0000 (GMT)
Message-ID: <d79baf40-6bb7-d4f4-666d-91e1ad20be74@linux.ibm.com>
Date:   Mon, 21 Mar 2022 09:10:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v6 4/5] ima: support fs-verity file digest based version 3
 signatures
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220318182151.100847-1-zohar@linux.ibm.com>
 <20220318182151.100847-5-zohar@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220318182151.100847-5-zohar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hSEeA2y0OdL23AynEl1JBxWYH7heLFX8
X-Proofpoint-GUID: hSEeA2y0OdL23AynEl1JBxWYH7heLFX8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_05,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 mlxscore=0 clxscore=1015 bulkscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 3/18/22 14:21, Mimi Zohar wrote:
> IMA may verify a file's integrity against a "good" value stored in the
> 'security.ima' xattr or as an appended signature, based on policy.  When
> the "good value" is stored in the xattr, the xattr may contain a file
> hash or signature.  In either case, the "good" value is preceded by a
> header.  The first byte of the xattr header indicates the type of data
> - hash, signature - stored in the xattr.  To support storing fs-verity
> signatures in the 'security.ima' xattr requires further differentiating
> the fs-verity signature from the existing IMA signature.
> 
> In addition the signatures stored in 'security.ima' xattr, need to be
> disambiguated.  Instead of directly signing the fs-verity digest, a new
> signature version 3 is defined as the hash of the ima_file_id structure,
> which identifies the type of signature and the digest.

Would it not be enough to just differentiat by the type of signature 
rather than also bumping the version? It's still signature_v2_hdr but a 
new type IMA_VERITY_DIGSIG is introduced there that shoud be sufficient 
to indicate that a different method for calculating the hash is to be 
used than for anything that existed before? sigv3 would then become the 
more obvious veriftysig... ?
