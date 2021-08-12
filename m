Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0533E9BB9
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Aug 2021 02:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbhHLAzZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 Aug 2021 20:55:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58608 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232704AbhHLAzY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 Aug 2021 20:55:24 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17C0Xi9q165976;
        Wed, 11 Aug 2021 20:54:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=ULNYVhyMXQ6SJqEPuIb/V3Ar+77kio3M9soDEn4mVZI=;
 b=U7vzE5v9UZZ45xrsck6jEvH7LjuhW/AIlkt6QO9HWq+MXbMHBhVbx9UM/7w4YTX7vZhI
 4hmxgbN0JetK1AXkuD6WJFss+1KlN1J26QS7kLYBKNmySgYwpclRLyJuMN8+ZKogCRa3
 8EI1LO/kmK56Z0Rz6OYRBtA3PlSJZPSMhutitZ5A31s92IkbBYNe7BmqUls7tv2pK4Mm
 HAIWQUQVTgSsUdDn5oH2Gzpzks4f5aJBQpzihj/AxFGmy5cCca+GtABs5NAPwTXgk+4J
 VXLJFA9IfsPKywQeMx2YezCCHX+mEYJrAqNomrLXSE3dHNiyAppYi+KGDJejY6yWcm34 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3abk4rb3nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 20:54:45 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17C0jLs3019800;
        Wed, 11 Aug 2021 20:54:44 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3abk4rb3n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 20:54:44 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17C0mr4b023293;
        Thu, 12 Aug 2021 00:54:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3abaq4bpt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 00:54:42 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17C0seAc57409946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 00:54:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC8B64C058;
        Thu, 12 Aug 2021 00:54:39 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF5AD4C044;
        Thu, 12 Aug 2021 00:54:35 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.39.92])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Aug 2021 00:54:35 +0000 (GMT)
Message-ID: <0e69a0aa394dd20347b06ae4e700aa17d52583ef.camel@linux.ibm.com>
Subject: Re: [PATCH v2] fscrypt: support trusted keys
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel@pengutronix.de,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        David Howells <dhowells@redhat.com>,
        linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 11 Aug 2021 20:54:34 -0400
In-Reply-To: <YRQF09f8st95yrFZ@gmail.com>
References: <20210806150928.27857-1-a.fatoum@pengutronix.de>
         <20210809094408.4iqwsx77u64usfx6@kernel.org> <YRGVcaquAJiuc8bp@gmail.com>
         <20210810180636.vqwaeftv7alsodgn@kernel.org> <YRLJmaafp941uOdA@gmail.com>
         <20210810212140.sdq5dq2wy5uaj7h7@kernel.org> <YRLvPJehAeMiYb2Z@gmail.com>
         <20210811001743.ofzkwdwa6rcjsf4d@kernel.org>
         <d4f5c2593380c82ceebae2c8782a1c440b35f165.camel@linux.ibm.com>
         <YRQF09f8st95yrFZ@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Bw0BKgjnxSvjPERnFY5J8y3TGYn8Lb-u
X-Proofpoint-GUID: nknNgAnVYtbwy3IFx8trALR_Z1mI68X2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-11_08:2021-08-11,2021-08-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120001
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2021-08-11 at 10:16 -0700, Eric Biggers wrote:

> Neither of you actually answered my question, which is whether the support for
> trusted keys in dm-crypt is a mistake.  I think you're saying that it is?  That
> would imply that fscrypt shouldn't support trusted keys, but rather encrypted
> keys -- which conflicts with Ahmad's patch which is adding support for trusted
> keys.  Note that your reasoning for this is not documented at all in the
> trusted-encrypted keys documentation; it needs to be (email threads don't really
> matter), otherwise how would anyone know when/how to use this feature?

True, but all of the trusted-encrypted key examples in the
documentation are "encrypted" type keys, encrypted/decrypted based on a
"trusted" type key.  There are no examples of using the "trusted" key
type directly.  Before claiming that adding "trusted" key support in
dm-crypt was a mistake, we should ask Ahmad why he felt dm-crypt needed
to directly support "trusted" type keys.

Mimi

