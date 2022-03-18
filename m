Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFA14DE2FC
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Mar 2022 21:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238313AbiCRU43 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 18 Mar 2022 16:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234633AbiCRU42 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 18 Mar 2022 16:56:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B701AA072;
        Fri, 18 Mar 2022 13:55:09 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22IIXEZF013069;
        Fri, 18 Mar 2022 20:55:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MgE2OTdMl1fgmgWIKOGl9q1PJ75sFNoa+qwLQ8o4xYg=;
 b=COwbQdjX/MXHjLKg7Jtz9ssJGGjEREMGQixWNZN5AWEDYYo5AQPdoz2r48tYi4QMNmNf
 MaOK/sKbJhPV01X3vCqeT+7wSPQ6MxX58Fdn98conkKrMomPP9mQqKbFDpY40kaljpAU
 RF+/8fYhP5G+Lda+ytBZHzl4U+5kxv+/wCX16dVkijA3r6+dtsekY3EFOrnnvoZbbx2x
 V2YtNuLSlGq3PClrRsqbuEB40ghC1lR2Wf+ZPhBrfseVecI+NH9ESJXLyvZlOLw9LHSk
 5TYZnSX5aj/odh7gHgn+K6eGZz7V+RsSI3DtEJ+pbp5H3hyBCMk1qS5v5HNaE7u8GFfa 7w== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3evj92s654-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 20:55:05 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22IKs2Yn032013;
        Fri, 18 Mar 2022 20:55:05 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 3etaj7m0en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 20:55:05 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22IKt3Wa28049790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 20:55:03 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 605706E056;
        Fri, 18 Mar 2022 20:55:03 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F4406E05B;
        Fri, 18 Mar 2022 20:55:02 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 18 Mar 2022 20:55:02 +0000 (GMT)
Message-ID: <e4af1e00-8eaa-259b-ad81-ec86682ea4af@linux.ibm.com>
Date:   Fri, 18 Mar 2022 16:55:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v6 5/5] fsverity: update the documentation
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220318182151.100847-1-zohar@linux.ibm.com>
 <20220318182151.100847-6-zohar@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220318182151.100847-6-zohar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7fuyGot6UiJEYAiTITeCkQjRXJT6VpAb
X-Proofpoint-ORIG-GUID: 7fuyGot6UiJEYAiTITeCkQjRXJT6VpAb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-18_14,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1011 phishscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 priorityscore=1501 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180109
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 3/18/22 14:21, Mimi Zohar wrote:
> Update the fsverity documentation related to IMA signature support.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>   Documentation/filesystems/fsverity.rst | 22 +++++++++++++---------
>   1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
> index 1d831e3cbcb3..28a47488848e 100644
> --- a/Documentation/filesystems/fsverity.rst
> +++ b/Documentation/filesystems/fsverity.rst
> @@ -74,8 +74,12 @@ authenticating the files is up to userspace.  However, to meet some
>   users' needs, fs-verity optionally supports a simple signature
>   verification mechanism where users can configure the kernel to require
>   that all fs-verity files be signed by a key loaded into a keyring; see
> -`Built-in signature verification`_.  Support for fs-verity file hashes
> -in IMA (Integrity Measurement Architecture) policies is also planned.
> +`Built-in signature verification`_.
> +
> +IMA supports including fs-verity file digests and signatures in the
> +IMA (Integrity Measurement Architecture) measurement list and

The Integrity Measurement Architecture (IMA) supports including ...

> +verifying fs-verity based file signatures stored as security.ima
> +xattrs, based on policy.
>   
>   User API
>   ========
> @@ -653,13 +657,13 @@ weren't already directly answered in other parts of this document.
>       hashed and what to do with those hashes, such as log them,
>       authenticate them, or add them to a measurement list.
>   
> -    IMA is planned to support the fs-verity hashing mechanism as an
> -    alternative to doing full file hashes, for people who want the
> -    performance and security benefits of the Merkle tree based hash.
> -    But it doesn't make sense to force all uses of fs-verity to be
> -    through IMA.  As a standalone filesystem feature, fs-verity
> -    already meets many users' needs, and it's testable like other
> -    filesystem features e.g. with xfstests.
> +    IMA supports the fs-verity hashing mechanism as an alternative
> +    to doing full file hashes, for people who want the performance

IMA supports the fs-verity hashing mechanism as an alternative to full 
file hashes for those who want the performance and security benefits ...

> +    and security benefits of the Merkle tree based hash.  But it
> +    doesn't make sense to force all uses of fs-verity to be through

However, it doesn't make sense ...

> +    IMA.  As a standalone filesystem feature, fs-verity already meets
> +    many users' needs, and it's testable like other filesystem
> +    features e.g. with xfstests.

Fs-verity already meets many user' needs even as a standalone filesystem 
feature and it is testable like other ...

>   
>   :Q: Isn't fs-verity useless because the attacker can just modify the
>       hashes in the Merkle tree, which is stored on-disk?
